module Runners
  class Processor::Coffeelint < Processor
    include Nodejs

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.npm.update_fields { |fields|
        fields.merge!({
                        file: string?,
                        # DO NOT ADD ANY OPTIONS in `options` option.
                        options: optional(object(
                                            file: string?,
                                            config: string?
                                          ))
                      })
      }
    end

    register_config_schema(name: :coffeelint, schema: Schema.runner_config)

    DEFAULT_DEPS = DefaultDependencies.new(
      main: Dependency.new(name: "coffeelint", version: "1.16.0"),
    )

    CONSTRAINTS = {
      "coffeelint" => Constraint.new(">= 1.16.0", "< 3.0.0"),
    }.freeze

    def self.ci_config_section_name
      'coffeelint'
    end

    def analyzer_name
      'CoffeeLint'
    end

    def setup
      add_warning_if_deprecated_options([:options], doc: "https://help.sider.review/tools/javascript/coffeelint")

      ensure_runner_config_schema(Schema.runner_config) do |config|
        begin
          install_nodejs_deps(DEFAULT_DEPS, constraints: CONSTRAINTS, install_option: config[:npm_install])
        rescue UserError => exn
          return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
        end

        analyzer # Must initialize after installation
        yield
      end
    end

    def analyze(_changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        check_runner_config(config) do |options|
          run_analyzer(options)
        end
      end
    end

    private

    def check_runner_config(config)
      file = file(config) || coffeelint_config(config)
      yield file
    end

    # NOTE: This is a deprecated option, and the option has been already undocumented.
    def coffeelint_config(config)
      config = config.dig(:options, :config)
      if config
        ['--file', "#{config}"]
      end
    end

    def file(config)
      file = config[:file] || config.dig(:options, :file)
      ['--file', "#{file}"] if file
    end

    def run_analyzer(options)
      # NOTE: CoffeeLint exits with 1 when any issues exist.
      stdout, stderr, _status = capture3(nodejs_analyzer_bin, '.', '--reporter', 'raw', *options)
      return Results::Failure.new(guid: guid, message: stderr, analyzer: analyzer) unless stderr.empty?

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        JSON.parse(stdout, symbolize_names: true).each do |file, issues|
          issues.each do |issue|
            line = issue[:lineNumber]
            loc = Location.new(
              start_line: line,
              start_column: nil,
              end_line: nil,
              end_column: nil,
            )
            # TODO: Use Structured issue
            message = issue[:message].dup
            message << " #{issue[:context]}" if issue[:context]
            result.add_issue Issue.new(
              path: relative_path(file.to_s),
              location: loc,
              id: issue[:rule] || issue[:name],
              message: message,
            )
          end
        end
      end
    end
  end
end
