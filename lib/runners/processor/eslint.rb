module Runners
  class Processor::Eslint < Processor
    include Nodejs

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, npm(
        target: target,
        dir: target, # deprecated
        ext: one_or_more_strings?,
        config: string?,
        'ignore-path': string?,
        'ignore-pattern': one_or_more_strings?,
        'no-ignore': boolean?,
        global: one_or_more_strings?,
        quiet: boolean?,
      )

      let :issue, object(
        severity: string,
        category: string?,
        recommended: enum?(boolean, string),
      )
    end

    register_config_schema SCHEMA.config

    Config.register_warnings do |config|
      config.add_warning_for_deprecated_option(analyzer: analyzer_id, old: :dir, new: :target)
    end

    CONSTRAINTS = {
      "eslint" => Gem::Requirement.new(">= 5.0.0", "< 8.0.0").freeze,
    }.freeze

    CUSTOM_FORMATTER = (Pathname(Dir.home) / "custom-eslint-json-formatter.js").to_path.freeze
    DEFAULT_ESLINT_CONFIG = (Pathname(Dir.home) / "sider_recommended_eslint.js").to_path.freeze
    DEFAULT_TARGET = ".".freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        dependencies:
          - my-eslint-plugin@2
        npm_install: false
        target:
          - src/
          - lib/
        ext: [.js, .jsx]
        config: config/.eslintrc.js
        ignore-path: config/.eslintignore
        ignore-pattern: "vendor/**"
        no-ignore: true
        global: ["require", "exports:true"]
        quiet: true
      YAML
    end

    def setup
      begin
        install_nodejs_deps constraints: CONSTRAINTS
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
      Array(config_linter[:target] || config_linter[:dir] || DEFAULT_TARGET)
    end

    def eslint_config
      path = config_linter[:config]
      if path && directory_traversal_attack?(path)
        path = nil
      end
      path
    end

    def ext
      ext = comma_separated_list(config_linter[:ext])
      ext ? ["--ext", ext] : []
    end

    def ignore_path
      ignore_path = config_linter[:'ignore-path']
      ignore_path ? ["--ignore-path", ignore_path] : []
    end

    def ignore_pattern
      Array(config_linter[:'ignore-pattern']).each_with_object([]) { |pat, flags| flags << "--ignore-pattern" << pat }
    end

    def no_ignore
      no_ignore = config_linter[:'no-ignore']
      no_ignore ? ["--no-ignore"] : []
    end

    def global
      global = comma_separated_list(config_linter[:global])
      global ? ["--global", global] : []
    end

    def quiet
      quiet = config_linter[:quiet]
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
            schema: SCHEMA.issue,
          )
        end
      end
    end

    def run_analyzer(config: nil)
      # NOTE: eslint exit with status code 1 when some issues are found.
      #       We use `capture3` instead of `capture3!`

      # NOTE: ESLint v5 returns 2 as exit status when fatal error is occurred.
      #       However, this runner doesn't depends on this behavior because it also supports ESLint v4
      #
      # @see https://eslint.org/docs/user-guide/command-line-interface#exit-codes

      # NOTE: We must use the `--output-file` option because some plugins may output a non-JSON text to STDOUT.
      #
      # @see https://github.com/typescript-eslint/typescript-eslint/blob/v2.6.0/packages/typescript-estree/src/parser.ts#L237-L247

      # NOTE: The `--no-error-on-unpatched-pattern` option has been available since v6.8.0.
      #
      # @see https://github.com/eslint/eslint/blob/v6.8.0/CHANGELOG.md
      # @see https://eslint.org/blog/2019/12/eslint-v6.8.0-released
      no_error_unmatched = Gem::Version.new(analyzer_version) >= Gem::Version.new("6.8.0") ? ["--no-error-on-unmatched-pattern"] : []

      _stdout, stderr, status = capture3(
        nodejs_analyzer_bin,
        "--format", CUSTOM_FORMATTER,
        "--output-file", report_file,
        "--no-color",
        *no_error_unmatched,
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
        FileUtils.copy_file(DEFAULT_ESLINT_CONFIG, ".eslintrc.js")
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
