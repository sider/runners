module NodeHarness
  module Runners
    module Coffeelint
      class Processor < NodeHarness::Processor
        include NodeHarness::Nodejs

        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.npm.update_fields { |fields|
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

        DEFAULT_DEPS = DefaultDependencies.new(
          main: Dependency.new(name: "coffeelint", version: "1.16.0"),
        )

        CONSTRAINTS = {
          "coffeelint" => Constraint.new(">= 1.16.0", "< 3.0.0"),
        }.freeze

        def self.ci_config_section_name
          'coffeelint'
        end

        def nodejs_analyzer_command
          "coffeelint"
        end

        def analyzer
          @analyzer ||= NodeHarness::Analyzer.new(name: 'CoffeeLint', version: nodejs_analyzer_version)
        end

        def setup
          ensure_runner_config_schema(Schema.runner_config) do |config|
            begin
              install_nodejs_deps(DEFAULT_DEPS, constraints: CONSTRAINTS, install_option: config[:npm_install])
            rescue UserError => exn
              return NodeHarness::Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
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
        #       At 2018-11-13, only 1 repository has enabled `config` option.
        # See:  https://app.compose.io/actcat-inc/deployments/sideci-production/mongodb/databases/sideci/collections/ci_configs/documents?find[query]={"ci_config.linter.coffeelint.options.config"%3A{"%24exists"%3Atrue}}&limit=10
        #       https://sider.review/admin/repositories/6875262
        def coffeelint_config(config)
          config = config.dig(:options, :config)
          if config
            add_warning("`config` option is deprecated. Use `file` instead of.", file: 'sideci.yml')
            ['--file', config.to_s]
          else
            []
          end
        end

        def file(config)
          file = config[:file] || config.dig(:options, :file)
          file ? ['--file', file] : []
        end

        def run_analyzer(options)
          # NOTE: CoffeeLint exits with 1 when any issues exist.
          stdout, stderr, _status = capture3(nodejs_analyzer_bin, '.', '--reporter', 'raw', *options)
          return NodeHarness::Results::Failure.new(guid: guid, message: stderr, analyzer: analyzer!) unless stderr.empty?

          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            JSON.parse(stdout, symbolize_names: true).each do |file, issues|
              issues.each do |issue|
                line = issue[:lineNumber]
                loc = NodeHarness::Location.new(
                  start_line: line,
                  start_column: nil,
                  end_line: nil,
                  end_column: nil,
                )
                # TODO: Use Structured issue
                message = issue[:message].dup
                message << " #{issue[:context]}" if issue[:context]
                result.add_issue NodeHarness::Issues::Text.new(
                  path: relative_path(file.to_s),
                  location: loc,
                  id: issue[:rule] || issue[:name],
                  message: message,
                  links: [],
                )
              end
            end
          end
        end
      end
    end
  end
end
