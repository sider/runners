module Runners
  class Processor::RailsBestPractices < Processor
    include Ruby

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

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
      GemInstaller::Spec.new("slim"),
      GemInstaller::Spec.new("haml"),
      GemInstaller::Spec.new("sass"),
      GemInstaller::Spec.new("sassc"),
      # HACK: sassc v1.x does not have `rake` dependency, but fail to install if the `rake` missing
      # https://github.com/sass/sassc-ruby/issues/86
      GemInstaller::Spec.new("rake"),
    ].freeze

    GEM_NAME = "rails_best_practices".freeze
    CONSTRAINTS = {
      GEM_NAME => Gem::Requirement.new(">= 1.19.1", "< 2.0").freeze,
    }.freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        gems:
          - { name: "rails_best_practices", version: "< 2" }
        vendor: false
        spec: true
        test: true
        features: true
        exclude: "app/models/excluded.rb,test/models/excluded_test.rb"
        only: "app/models/only1.rb,app/models/only2.rb"
        config: .rails_best_practices.yml
      YAML
    end

    def setup
      add_warning_if_deprecated_options

      prepare_config
      install_gems(default_gem_specs(GEM_NAME), optionals: OPTIONAL_GEMS, constraints: CONSTRAINTS) { yield }
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(_changes)
      run_analyzer
    end

    private

    def option_vendor
      vendor = config_linter[:vendor]
      vendor = config_linter.dig(:options, :vendor) if vendor.nil?
      if vendor == false
        []
      else
        ["--vendor"]
      end
    end

    def option_spec
      spec = config_linter[:spec] || config_linter.dig(:options, :spec)
      spec ? ["--spec"] : []
    end

    def option_test
      test = config_linter[:test] || config_linter.dig(:options, :test)
      test ? ["--test"] : []
    end

    def option_features
      features = config_linter[:features] || config_linter.dig(:options, :features)
      features ? ["--features"] : []
    end

    def option_exclude
      exclude = config_linter[:exclude] || config_linter.dig(:options, :exclude)
      exclude ? ["--exclude", exclude] : []
    end

    def option_only
      only = config_linter[:only] || config_linter.dig(:options, :only)
      only ? ["--only", only] : []
    end

    def option_config
      config = config_linter[:config] || config_linter.dig(:options, :config)
      config ? ["--config", config] : []
    end

    def prepare_config
      # NOTE: We expect sider_rails_best_practices.yml to be located in $HOME.
      default_config = Pathname(Dir.home) / 'sider_rails_best_practices.yml'
      path = current_dir / 'config' / 'rails_best_practices.yml'
      return if path.exist?
      path.parent.mkpath
      FileUtils.copy_file(default_config, path)
    end

    def run_analyzer
      cmd = ruby_analyzer_command(
        '--without-color',
        '--silent',
        '--output-file', report_file,
        '--format', 'yaml',
        *option_vendor,
        *option_spec,
        *option_test,
        *option_features,
        *option_exclude,
        *option_only,
        *option_config,
      )

      # NOTE: rails_best_practices exit with status code n (issue count)
      #       when some issues are found.
      #       We use `capture3` instead of `capture3!`
      capture3(cmd.bin, *cmd.args)

      # NOTE: rails_best_practices returns top-level YAML array with tags.
      #       We want to just parse a YAML, so we remove YAML tags before passing.
      output = read_report_file
      output.gsub!('- !ruby/object:RailsBestPractices::Core::Error', '-')

      issues = YAML.safe_load(output, symbolize_names: true, filename: report_file)
      unless issues.is_a? Array
        raise "Invalid YAML result: `#{issues.inspect}`"
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        issues.each do |issue|
          # HACK: `line_number` sometimes is not a number.
          line_number = issue.fetch(:line_number)
          start_line = Integer(line_number, exception: false)
          location = if start_line
                       Location.new(start_line: start_line)
                     else
                       file = relative_path(issue.fetch(:filename)).to_path
                       add_warning "Invalid `line_number` is output: #{line_number.inspect}. The line location in `#{file}` is lost.", file: file
                       nil
                     end

          result.add_issue Issue.new(
            path: relative_path(issue.fetch(:filename)),
            location: location,
            id: issue.fetch(:type),
            message: issue.fetch(:message),
            links: Array(issue[:url]),
          )
        end
      end
    end
  end
end
