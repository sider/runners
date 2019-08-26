module NodeHarness
  module Runners
    module Tslint
      class Processor < NodeHarness::Processor
        include NodeHarness::Nodejs

        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.npm.update_fields { |fields|
            fields.merge!({
                            glob: string?,
                            config: string?,
                            exclude: enum?(string, array(string)),
                            project: string?,
                            'rules-dir': enum?(string, array(string)),
                            'type-check': boolean?,
                            # DO NOT ADD ANY OPTIONS in `options` option.
                            options: optional(object(
                                                config: string?,
                                                exclude: enum?(string, array(string)),
                                                project: string?,
                                                'rules-dir': string?,
                                                'type-check': boolean?
                                              ))
                          })
          }
        end

        DEFAULT_DEPS = DefaultDependencies.new(
          main: Dependency.new(name: "tslint", version: "5.18.0"),
          extras: [
            Dependency.new(name: "typescript", version: "3.4.3"),
          ],
        ).freeze

        CONSTRAINTS = {
          "tslint" => Constraint.new(">= 5.0.0", "< 6.0.0"),
        }.freeze

        def self.ci_config_section_name
          'tslint'
        end

        def nodejs_analyzer_command
          "tslint"
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

        def analyzer
          @analyzer ||= NodeHarness::Analyzer.new(name: 'TSLint', version: nodejs_analyzer_version)
        end

        def analyze(_changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            check_runner_config(config) do |target, options|
              run_analyzer(target, options)
            end
          end
        end

        private

        def check_runner_config(config)
          # Target
          target = target_glob(config)

          # Additional Options
          tslint_config = tslint_config(config)
          exclude = exclude(config)
          project = project(config)
          rules_dir = rules_dir(config)
          type_check = type_check(config)

          additional_options = [tslint_config, exclude, project, rules_dir, type_check].flatten.compact
          yield target, additional_options
        end

        def target_glob(config)
          config[:glob] || '**/*.ts{,x}'
        end

        def tslint_config(config)
          config = config[:config] || config.dig(:options, :config)
          config ? ["--config", "#{config}"] : []
        end

        def exclude(config)
          exclude = config[:exclude] || config.dig(:options, :exclude)
          if exclude
            Array(exclude).map { |v| ["--exclude", v] }.flatten
          else
            ["--exclude", "node_modules/**"]
          end
        end

        def project(config)
          project = config[:project] || config.dig(:options, :project)
          project ? ["--project", "#{project}"] : []
        end

        def rules_dir(config)
          # FIXME: This `@type` comment is unneeded ideally.
          # @type var config: any
          rules_dir = config[:'rules-dir'] || config.dig(:options, :'rules-dir')
          Array(rules_dir || []).map { |dir| ["--rules-dir", dir] }.flatten
        end

        def type_check(config)
          # FIXME: This `@type` comment is unneeded ideally.
          # @type var config: any
          type_check = config[:'type-check'] || config.dig(:options, :'type-check')
          "--type-check" if type_check
        end

        def run_analyzer(target, options)
          stdout, stderr, status = capture3(
            nodejs_analyzer_bin,
            '--format',
            'json',
            *options,
            target,
          )
          # The CLI process may exit with the following codes:
          # 0: Linting succeeded without errors (warnings may have ocurred)
          # 1: An invalid command line argument, combination thereof was used, or compilation error with `--type-check`
          # 2: Linting failed with one or more rule violations with severity error
          unless status.exitstatus == 0 || status.exitstatus == 2
            return NodeHarness::Results::Failure.new(guid: guid, message: stderr, analyzer: analyzer!)
          end

          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            JSON.parse(stdout, symbolize_names: true).each do |issue|
              # NOTE: With --format=json, startPosition.line is zero-based numbering, that's why `+ 1` is added.
              #
              # @see https://github.com/palantir/tslint/blob/05cfde7c6eb53c373ea0d6ae1e793cc2dc639dc3/src/formatters/proseFormatter.ts#L57
              loc = NodeHarness::Location.new(start_line: issue[:startPosition][:line] + 1,
                                              start_column: nil,
                                              end_line: issue[:endPosition][:line] + 1,
                                              end_column: nil)
              result.add_issue NodeHarness::Issues::Text.new(
                path: relative_path(issue[:name]),
                location: loc,
                id: issue[:ruleName],
                message: "#{issue[:failure]} (#{issue[:ruleName]})",
                links: [],
              )
            end
          end
        end
      end
    end
  end
end
