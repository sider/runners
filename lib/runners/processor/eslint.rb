module Runners
  class Processor::Eslint < Processor
    include Nodejs

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.npm.update_fields { |fields|
        fields.merge!({
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
      "eslint" => Constraint.new(">= 5.0.0", "< 7.0.0")
    }.freeze

    def setup
      add_warning_if_deprecated_options([:options])

      begin
        install_nodejs_deps(constraints: CONSTRAINTS, install_option: config_linter[:npm_install])
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
      end
      analyzer
      yield
    end

    def analyze(_changes)
      additional_options = [eslint_config, ext, ignore_path, ignore_pattern, no_ignore, global, quiet].flatten.compact
      run_analyzer(dir, additional_options)
    end

    private

    def dir
      dir = config_linter[:dir] || config_linter.dig(:options, :dir) || '.'
      Array(dir)
    end

    def eslint_config
      conf = user_specified_eslint_config_path
      "--config=#{conf}" if conf
    end

    def user_specified_eslint_config_path
      path = config_linter[:config] || config_linter.dig(:options, :config)
      if path && directory_traversal_attack?(path)
        path = nil
      end
      path
    end

    def ext
      ext = config_linter[:ext] || config_linter.dig(:options, :ext)
      "--ext=#{ext}" if ext
    end

    def ignore_path
      ignore_path = config_linter[:'ignore-path'] || config_linter.dig(:options, :'ignore-path')
      "--ignore-path=#{ignore_path}" if ignore_path
    end

    def ignore_pattern
      ignore_pattern = config_linter[:'ignore-pattern'] || config_linter.dig(:options, :'ignore-pattern')
      pattern = Array(ignore_pattern)
      unless pattern.empty?
        pattern.map { |value| "--ignore-pattern=#{value}" }
      end
    end

    def no_ignore
      no_ignore = config_linter[:'no-ignore'] || config_linter.dig(:options, :'no-ignore')
      "--no-ignore" if no_ignore
    end

    def global
      global = config_linter[:global] || config_linter.dig(:options, :global)
      "--global='#{global}'" if global
    end

    def quiet
      quiet = config_linter[:quiet] || config_linter.dig(:options, :quiet)
      "--quiet" if quiet
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

    def new_location(start_line, start_column, end_line, end_column)
      case
      when start_line && start_column && end_line && end_column
        Location.new(start_line: start_line, start_column: start_column, end_line: end_line, end_column: end_column)
      when start_line && end_line
        Location.new(start_line: start_line, end_line: end_line)
      when start_line
        Location.new(start_line: start_line)
      else
        nil
      end
    end

    # @see https://eslint.org/docs/developer-guide/working-with-custom-formatters#the-results-object
    def parse_result(result)
      result.each do |issue|
        path = relative_path(issue[:filePath])
        # ESLint informs errors as an array if ESLint detects errors in a file.
        issue[:messages].each do |details|
          id = details[:ruleId]
          message = details[:message]

          unless id
            trace_writer.message("No rule ID found! - #{message} in #{path}")
            id = Digest::SHA1.hexdigest(message)
          end

          yield Issue.new(
            path: path,
            location: new_location(details[:line], details[:column], details[:endLine], details[:endColumn]),
            id: id,
            message: message,
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

    def run_analyzer(target_dir, additional_options)
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
        "--format=#{custom_formatter}",
        "--output-file=#{report_file}",
        "--no-color",
        *additional_options,
        *target_dir
      )

      output_json = report_file_exist? ? read_report_json { nil } : nil

      if [0, 1].include?(status.exitstatus) && output_json
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          parse_result(output_json) { |issue| result.add_issue(issue) }
        end
      elsif no_linting_files?(stderr)
        Results::Success.new(guid: guid, analyzer: analyzer)
      else
        Results::Failure.new(guid: guid, message: stderr.strip, analyzer: analyzer)
      end
    end

    def custom_formatter
      (Pathname(Dir.home) / "custom-eslint-json-formatter.js").realpath
    end

    # NOTE: Linting nonexistent files is a fatal error since v5.0.0.
    # @see https://eslint.org/docs/user-guide/migrating-to-5.0.0#-linting-nonexistent-files-from-the-command-line-is-now-a-fatal-error
    def no_linting_files?(stderr)
      stderr.match?(/No files matching the pattern ".+" were found/)
    end
  end
end
