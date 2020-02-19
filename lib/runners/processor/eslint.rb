module Runners
  class Processor::Eslint < Processor
    include Nodejs

    Schema = StrongJSON.new do
      let :runner_config, Schema::RunnerConfig.npm.update_fields { |fields|
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

        let :issue, object(
          severity: string,
          category: string?,
          recommended: enum?(boolean, string),
        )
      }
    end

    DEFAULT_DEPS = DefaultDependencies.new(main: Dependency.new(name: "eslint", version: "6.8.0"))
    CONSTRAINTS = {
      "eslint" => Constraint.new(">= 5.0.0", "< 7.0.0")
    }.freeze

    def self.ci_config_section_name
      'eslint'
    end

    def analyzer_name
      'ESLint'
    end

    def setup
      add_warning_if_deprecated_options([:options], doc: "https://help.sider.review/tools/javascript/eslint")

      ensure_runner_config_schema(Schema.runner_config) do |config|
        begin
          install_nodejs_deps(DEFAULT_DEPS, constraints: CONSTRAINTS, install_option: config[:npm_install])
        rescue UserError => exn
          return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
        end
        analyzer
        yield
      end
    end

    def analyze(changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        check_runner_config(config) do |dir, additional_options|
          run_analyzer(dir, additional_options)
        end
      end
    end

    private

    def check_runner_config(config)
      # Required option, which has the default value.
      dir = dir(config)

      # Additional options
      eslint_config = eslint_config(config)
      ext = ext(config)
      ignore_path = ignore_path(config)
      ignore_pattern = ignore_pattern(config)
      no_ignore = no_ignore(config)
      global = global(config)
      quiet = quiet(config)

      additional_options = [eslint_config, ext, ignore_path, ignore_pattern, no_ignore, global, quiet].flatten.compact
      yield dir, additional_options
    end

    def dir(config)
      dir = config[:dir] || config.dig(:options, :dir) || '.'
      Array(dir)
    end

    def eslint_config(config)
      conf = user_specified_eslint_config_path(config)
      "--config=#{conf}" if conf
    end

    def user_specified_eslint_config_path(config)
      path = config[:config] || config.dig(:options, :config)
      if path && directory_traversal_attack?(path)
        path = nil
      end
      path
    end

    def ext(config)
      ext = config[:ext] || config.dig(:options, :ext)
      "--ext=#{ext}" if ext
    end

    def ignore_path(config)
      ignore_path = config[:'ignore-path'] || config.dig(:options, :'ignore-path')
      "--ignore-path=#{ignore_path}" if ignore_path
    end

    def ignore_pattern(config)
      ignore_pattern = config[:'ignore-pattern'] || config.dig(:options, :'ignore-pattern')
      pattern = Array(ignore_pattern)
      unless pattern.empty?
        pattern.map { |value| "--ignore-pattern=#{value}" }
      end
    end

    def no_ignore(config)
      no_ignore = config[:'no-ignore'] || config.dig(:options, :'no-ignore')
      "--no-ignore" if no_ignore
    end

    def global(config)
      global = config[:global] || config.dig(:options, :global)
      "--global='#{global}'" if global
    end

    def quiet(config)
      quiet = config[:quiet] || config.dig(:options, :quiet)
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
    def parse_result(stdout)
      JSON.parse(stdout, symbolize_names: true).each do |issue|
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
      output_file = working_dir / "eslint-output-#{Time.now.to_i}.json"

      _stdout, stderr, status = capture3(
        nodejs_analyzer_bin,
        "--format=#{custom_formatter}",
        "--output-file=#{output_file}",
        '--no-color',
        *additional_options,
        *target_dir
      )

      output_json =
        if output_file.exist?
          output_file.read.tap { |json| trace_writer.message json }
        else
          nil
        end

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
