module Runners
  class Processor::Eslint < Processor
    include Nodejs

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.npm.update_fields { |fields|
        fields.merge!({
                        target: enum?(string, array(string)),
                        dir: enum?(string, array(string)),
                        ext: string?,
                        config: string?,
                        'ignore-path': string?,
                        'ignore-pattern': enum?(string, array(string)),
                        'no-ignore': boolean?,
                        global: string?,
                        quiet: boolean?,
                        # NOTE: DO NOT ADD ANY OPTIONS to internal `options` option because the option has been deprecated.
                        options: optional(object(
                                            npm_install: enum?(boolean, literal('development'), literal('production')),
                                            dir: enum?(string, array(string)),
                                            ext: string?,
                                            config: string?,
                                            'ignore-path': string?,
                                            'no-ignore': boolean?,
                                            'ignore-pattern': enum?(string, array(string)),
                                            global: string?,
                                            quiet: boolean?
                                          ))
                      })
      }

      let :issue, object(
        severity: string,
        category: string?,
        recommended: enum?(boolean, string),
      )
    end

    register_config_schema(name: :eslint, schema: Schema.runner_config)

    CONSTRAINTS = {
      "eslint" => Constraint.new(">= 5.0.0", "< 8.0.0")
    }.freeze

    CUSTOM_FORMATTER = (Pathname(Dir.home) / "eslint" / "custom-eslint-json-formatter.js").to_path.freeze
    DEFAULT_ESLINT_CONFIG = (Pathname(Dir.home) / "eslint" / "sider_eslintrc.yml").to_path.freeze
    DEFAULT_TARGET = ".".freeze

    def setup
      add_warning_if_deprecated_options
      add_warning_for_deprecated_option :dir, to: :target

      begin
        install_nodejs_deps(constraints: CONSTRAINTS, install_option: config_linter[:npm_install])
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
      end

      yield
    end

    def analyze(_changes)
      run_analyzer config: eslint_config
    end

    private

    def target
      Array(config_linter[:target] || config_linter[:dir] ||
            config_linter.dig(:options, :dir) || DEFAULT_TARGET)
    end

    def eslint_config
      path = config_linter[:config] || config_linter.dig(:options, :config)
      if path && directory_traversal_attack?(path)
        path = nil
      end
      path
    end

    def ext
      ext = config_linter[:ext] || config_linter.dig(:options, :ext)
      ext ? ["--ext", ext] : []
    end

    def ignore_path
      ignore_path = config_linter[:'ignore-path'] || config_linter.dig(:options, :'ignore-path')
      ignore_path ? ["--ignore-path", ignore_path] : []
    end

    def ignore_pattern
      ignore_pattern = config_linter[:'ignore-pattern'] || config_linter.dig(:options, :'ignore-pattern')
      Array(ignore_pattern).flat_map { |value| ["--ignore-pattern", value] }
    end

    def no_ignore
      no_ignore = config_linter[:'no-ignore'] || config_linter.dig(:options, :'no-ignore')
      no_ignore ? ["--no-ignore"] : []
    end

    def global
      global = config_linter[:global] || config_linter.dig(:options, :global)
      global ? ["--global", global] : []
    end

    def quiet
      quiet = config_linter[:quiet] || config_linter.dig(:options, :quiet)
      quiet ? ["--quiet"] : []
    end

    # @see https://eslint.org/docs/user-guide/configuring#configuring-rules
    def normalize_severity(severity)
      case severity
      when 1
        'warn'
      when 2
        'error'
      else
        raise "Unknown severity: #{severity.inspect}"
      end
    end

    # @see https://eslint.org/docs/developer-guide/working-with-custom-formatters#the-results-object
    def parse_result(result)
      result.each do |issue|
        path = relative_path(issue[:filePath])
        # ESLint informs errors as an array if ESLint detects errors in a file.
        issue[:messages].each do |details|
          yield Issue.new(
            path: path,
            location: details[:line] ? Location.new(
              start_line: details[:line],
              start_column: details[:column],
              end_line: details[:endLine],
              end_column: details[:endColumn],
            ) : nil,
            id: details[:ruleId],
            message: details[:message],
            links: Array(details.dig(:docs, :url)),
            object: {
              severity: normalize_severity(details[:severity]),
              category: details.dig(:docs, :category),
              recommended: details.dig(:docs, :recommended),
            },
            schema: Schema.issue,
          )
        end
      end
    end

    def run_analyzer(config: nil)
      # NOTE: eslint exit with status code 1 when some issues are found.
      #       We use `capture3` instead of `capture3!`
      #
      # NOTE: ESLint v5 returns 2 as exit status when fatal error is occurred.
      #       However, this runner doesn't depends on this behavior because it also supports ESLint v4
      #
      # @see https://eslint.org/docs/user-guide/command-line-interface#exit-codes

      # NOTE: We must use the `--output-file` option because some plugins may output a non-JSON text to STDOUT.
      #
      # @see https://github.com/typescript-eslint/typescript-eslint/blob/v2.6.0/packages/typescript-estree/src/parser.ts#L237-L247

      _stdout, stderr, status = capture3(
        nodejs_analyzer_bin,
        "--format", CUSTOM_FORMATTER,
        "--output-file", report_file,
        "--no-color",
        *(config ? ["--config", config] : []),
        *ext,
        *ignore_path,
        *ignore_pattern,
        *no_ignore,
        *global,
        *quiet,
        *target
      )

      output_json = report_file_exist? ? read_report_json { nil } : nil

      if [0, 1].include?(status.exitstatus) && output_json
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          parse_result(output_json) { |issue| result.add_issue(issue) }
        end
      elsif no_linting_files?(stderr)
        Results::Success.new(guid: guid, analyzer: analyzer)
      elsif no_eslint_config?(stderr)
        trace_writer.message "Retrying with the default configuration file because no configuration files were found..."
        FileUtils.copy(DEFAULT_ESLINT_CONFIG, ".eslintrc.yml")
        run_analyzer
      else
        Results::Failure.new(guid: guid, analyzer: analyzer)
      end
    end

    # NOTE: Linting nonexistent files is a fatal error since v5.0.0.
    # @see https://eslint.org/docs/user-guide/migrating-to-5.0.0#-linting-nonexistent-files-from-the-command-line-is-now-a-fatal-error
    def no_linting_files?(stderr)
      stderr.match?(/No files matching the pattern ".+" were found/)
    end

    def no_eslint_config?(stderr)
      eslint_config.nil? && stderr.include?("ESLint couldn't find a configuration file")
    end
  end
end
