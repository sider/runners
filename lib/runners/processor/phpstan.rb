module Runners
  class Processor::Phpstan < Processor
    include PHP

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!(
          target: enum?(string, array(string)),
          configuration: string?,
          level: enum?(numeric, literal("max")),
          "autoload-file": string?,
        )

        let :issue, object(
          ignorable: boolean,
          tip: string?,
        )
      }
    end

    register_config_schema(name: :phpstan, schema: Schema.runner_config)

    DEFAULT_TARGET = ".".freeze

    def analyze
      run_analyzer
    end

    private

    def analysis_targets
      targets = Array(config_linter[:target])
      targets.empty? ? [DEFAULT_TARGET] : targets
    end

    def option_configuration
      config_linter[:configuration].then { |v| v ? ["--configuration", v] : [] }
    end

    def option_level
      config_linter[:level].then { |v| v ? ["--level", l] : [] }
    end

    def option_autoload_file
      config_linter[:"autoload-file"].then { |v| v ? ["autoload-file", v] : [] }
    end

    def run_analyzer
      stdout, stderr, _status = capture3(
        analyzer_bin,
        "analyse",
        "--error-format=sider",
        "--no-progress",
        "--no-ansi",
        *option_configuration,
        *option_level,
        *option_autoload_file,
        *analysis_targets,
      )

      raise stderr if stderr.present?

      errors = JSON.parse(stdout, symbolize_names: true)
      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        errors.each do |error|
          result.add_issue Issue.new(
            id: error[:message],
            location: Location.new(start_line: error[:line]),
            path: relative_path(error[:file]),
            message: error[:message],
            links: [],
            object: {
              ignorable: error[:canBeIgnored],
              tip: error[:tip],
            },
            schema: Schema.issue,
          )
        end
      end
    end
  end
end
