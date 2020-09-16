module Runners
  class Processor::Coffeelint < Processor
    include Nodejs

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass
      let :runner_config, Runners::Schema::BaseConfig.npm.update_fields { |fields|
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

    CONSTRAINTS = {
      "coffeelint" => Constraint.new(">= 1.16.0", "< 3.0.0"),
    }.freeze

    def setup
      add_warning_if_deprecated_options

      begin
        install_nodejs_deps(constraints: CONSTRAINTS, install_option: config_linter[:npm_install])
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
      end

      yield
    end

    def analyze(_changes)
      # NOTE: CoffeeLint exits with 1 when any issues exist.
      stdout, stderr, _status = capture3(nodejs_analyzer_bin, '.', '--reporter', 'raw', *config_file)

      unless stderr.empty?
        return Results::Failure.new(guid: guid, analyzer: analyzer)
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        JSON.parse(stdout, symbolize_names: true).each do |file, issues|
          path = relative_path(file.to_s)
          issues.each do |issue|
            message = issue[:message].dup
            message << " #{issue[:context]}" if issue[:context]
            result.add_issue Issue.new(
              path: path,
              location: Location.new(start_line: issue[:lineNumber]),
              id: issue[:rule] || issue[:name],
              message: message,
            )
          end
        end
      end
    end

    private

    def config_file
      file = config_linter[:file] || config_linter.dig(:options, :file) || config_linter.dig(:options, :config)
      file ? ['--file', file] : []
    end
  end
end
