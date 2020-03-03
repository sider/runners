module Runners
  class Processor::Tslint < Processor
    include Nodejs

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.npm.update_fields { |fields|
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

    register_config_schema(name: :tslint, schema: Schema.runner_config)

    DEFAULT_DEPS = DefaultDependencies.new(
      main: Dependency.new(name: "tslint", version: "6.0.0"),
      extras: [
        Dependency.new(name: "typescript", version: "3.7.5"),
      ],
    )

    CONSTRAINTS = {
      "tslint" => Constraint.new(">= 5.0.0", "< 7.0.0"),
    }.freeze

    def setup
      add_warning_for_deprecated_linter(alternative: "ESLint",
                                        ref: "https://github.com/palantir/tslint/issues/4534",
                                        deadline: Time.new(2020, 12, 1))

      begin
        install_nodejs_deps(DEFAULT_DEPS, constraints: CONSTRAINTS, install_option: config_linter[:npm_install])
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
      end

      analyzer # Must initialize after installation
      yield
    end

    def analyzer_name
      'TSLint'
    end

    def analyze(_changes)
      options = [tslint_config, exclude, project, rules_dir, type_check].flatten.compact
      run_analyzer(target_glob, options)
    end

    private

    def target_glob
      if config_linter[:glob]
        config_linter[:glob]
      else
        '**/*.ts{,x}'
      end
    end

    def tslint_config
      config = config_linter[:config] || config_linter.dig(:options, :config)
      ["--config", "#{config}"] if config
    end

    def exclude
      exclude = config_linter[:exclude] || config_linter.dig(:options, :exclude)
      if exclude
        Array(exclude).map { |v| ["--exclude", v] }.flatten
      else
        ["--exclude", "node_modules/**"]
      end
    end

    def project
      project = config_linter[:project] || config_linter.dig(:options, :project)
      ["--project", "#{project}"] if project
    end

    def rules_dir
      rules_dir = config_linter[:'rules-dir'] || config_linter.dig(:options, :'rules-dir')
      if rules_dir
        Array(rules_dir).map { |dir| ["--rules-dir", dir] }.flatten
      end
    end

    def type_check
      type_check = config_linter[:'type-check'] || config_linter.dig(:options, :'type-check')
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
        return Results::Failure.new(guid: guid, message: stderr, analyzer: analyzer)
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        JSON.parse(stdout, symbolize_names: true).each do |issue|
          # NOTE: With --format=json, startPosition.line is zero-based numbering, that's why `+ 1` is added.
          #
          # @see https://github.com/palantir/tslint/blob/05cfde7c6eb53c373ea0d6ae1e793cc2dc639dc3/src/formatters/proseFormatter.ts#L57
          loc = Location.new(start_line: issue[:startPosition][:line] + 1,
                                          start_column: nil,
                                          end_line: issue[:endPosition][:line] + 1,
                                          end_column: nil)
          result.add_issue Issue.new(
            path: relative_path(issue[:name]),
            location: loc,
            id: issue[:ruleName],
            message: issue[:failure],
          )
        end
      end
    end
  end
end
