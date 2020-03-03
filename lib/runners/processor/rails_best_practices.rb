module Runners
  class Processor::RailsBestPractices < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.ruby.update_fields { |fields|
        fields.merge!({
                        vendor: boolean?,
                        spec: boolean?,
                        test: boolean?,
                        features: boolean?,
                        exclude: string?,
                        only: string?,
                        config: string?,
                        # DO NOT ADD ANY OPTION under `options`.
                        options: optional(object(
                                            vendor: boolean?,
                                            spec: boolean?,
                                            test: boolean?,
                                            features: boolean?,
                                            exclude: string?,
                                            only: string?,
                                            config: string?,
                                          ))
                      })
      }
    end

    register_config_schema(name: :rails_best_practices, schema: Schema.runner_config)

    OPTIONAL_GEMS = [
      GemInstaller::Spec.new(name: "slim", version: []),
      GemInstaller::Spec.new(name: "haml", version: []),
      GemInstaller::Spec.new(name: "sass", version: []),
      GemInstaller::Spec.new(name: "sassc", version: []),
      # HACK: sassc v1.x does not have `rake` dependency, but fail to install if the `rake` missing
      # https://github.com/sass/sassc-ruby/issues/86
      GemInstaller::Spec.new(name: "rake", version: []),
    ].freeze

    CONSTRAINTS = {
      "rails_best_practices" => [">= 1.19.1", "< 2.0"]
    }.freeze

    def setup
      add_warning_if_deprecated_options([:options])

      prepare_config
      install_gems default_gem_specs, optionals: OPTIONAL_GEMS, constraints: CONSTRAINTS do
        analyzer
        yield
      end
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(_changes)
      options = [vendor, spec, test, features, exclude, only, config_option].compact
      run_analyzer(options)
    end

    private

    def vendor
      vendor = config_linter[:vendor]
      vendor = config_linter.dig(:options, :vendor) if vendor.nil?
      if vendor == false
        nil
      else
        "--vendor"
      end
    end

    def spec
      spec = config_linter[:spec] || config_linter.dig(:options, :spec)
      "--spec" if spec
    end

    def test
      test = config_linter[:test] || config_linter.dig(:options, :test)
      "--test" if test
    end

    def features
      features = config_linter[:features] || config_linter.dig(:options, :features)
      "--features" if features
    end

    def exclude
      exclude = config_linter[:exclude] || config_linter.dig(:options, :exclude)
      "--exclude=#{exclude}" if exclude
    end

    def only
      only = config_linter[:only] || config_linter.dig(:options, :only)
      "--only=#{only}" if only
    end

    def config_option
      config = config_linter[:config] || config_linter.dig(:options, :config)
      "--config=#{config}" if config
    end

    def prepare_config
      # NOTE: We expect sider_rails_best_practices.yml to be located in $HOME.
      default_config = Pathname(Dir.home) / 'sider_rails_best_practices.yml'
      path = Pathname("#{current_dir.to_s}/config/rails_best_practices.yml")
      return if path.exist?
      path.parent.mkpath
      FileUtils.cp(default_config, path)
    end

    def run_analyzer(options)
      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        # NOTE: rails_best_practices exit with status code n (issue count)
        #       when some issues are found.
        #       We use `capture3` instead of `capture3!`
        stdout, _, _ = capture3(
          *ruby_analyzer_bin,
          '--without-color',
          '--silent',
          '--output-file=/dev/stdout',
          '--format=yaml',
          *options
        )
        # NOTE: rails_best_practices returns top-level YAML array with tags.
        #       We want to just parse a YAML, so we remove YAML tags before passing to `YAML.load`.
        YAML.load(stdout.gsub('- !ruby/object:RailsBestPractices::Core::Error', '-'), symbolize_names: true).each do |yaml|
          loc = Location.new(
            start_line: yaml.fetch(:line_number).to_i,
            start_column: 0,
            end_line: yaml.fetch(:line_number).to_i,
            end_column: 0
          )
          result.add_issue Issue.new(
            path: relative_path(yaml.fetch(:filename)),
            location: loc,
            id: yaml.fetch(:type),
            message: yaml.fetch(:message),
            links: [yaml[:url]].compact
          )
        end
      end
    end
  end
end
