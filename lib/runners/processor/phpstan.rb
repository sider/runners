module Runners
  class Processor::Phpstan < Processor
    include PHP

    DEFAULT_LEVEL = 4.freeze

    Schema = StrongJSON.new do
      let :runner_config, Schema::RunnerConfig.base.update_fields { |fields|
        fields.merge!({
                        glob: string?,
                        configuration: string?,
                        level: numeric?,
                        "autoload-file": string?,
                        # DO NOT ADD ANY OPTIONS in `options` option.
                        options: optional(object(
                                          configuration: string?,
                                          level: numeric?,
                                          "autoload-file": string?,
                                          ))
                      })
      }
    end

    def self.ci_config_section_name
      "phpstan"
    end

    def analyzer_name
      "phpstan"
    end

    def setup
      # add_warning_if_deprecated_options([:options], doc: "https://help.sider.review/tools/php/phpstan")
      yield
    end

    def analyze changes
      ensure_runner_config_schema(Schema.runner_config) do |config|
        check_runner_config(config) do |targets, options|
          run_analyzer(changes, targets, options)
        end
      end
    end

    private

    def check_runner_config config
      target = target_glob config
      # Additional options.
      level = level config
      configuration = configuration config
      autoload_file = autoload_file config

      options = [level, configuration, autoload_file].flatten.compact
      yield target, options
    end

    def target_glob config
      config[:glob] || "src"
    end

    def level config
      level = config[:level] || config.dig(:options, :level) || DEFAULT_LEVEL
      ["--level", level.to_s]
    end

    def configuration config
      configuration = config[:configuration] || config.dig(:options, :configuration)
      ["--configuration", configuration] if configuration
    end

    def autoload_file config
      autoload_file = config[:"autoload-file"] || config.dig(:options, :"autoload-file")
      ["--autoload-file", "#{autoload_file}"] if autoload_file
    end

    def run_analyzer changes, targets, options
      stdout, stderr, status = capture3(
        analyzer_bin,
        "analyse",
        "--error-format",
        "json",
        *options,
        targets,
      )

      if stdout.blank?
        return Results::Failure.new(guid: guid, message: stderr, analyzer: analyzer)
      end

      result_parse = JSON.parse(stdout, symbolize_names: true)
      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        result_parse[:files].each do |key, value|
          value[:messages].each do |message|
            loc = Location.new(start_line: message[:line])
            result.add_issue Issue.new(
              path: relative_path(key.to_s),
              location: loc,
              id: message[:message],
              message: message[:message],
            )
          end
        end
      end
    end
  end
end
