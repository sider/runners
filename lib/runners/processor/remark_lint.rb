module Runners
  class Processor::RemarkLint < Processor
    include Nodejs

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.npm.update_fields { |fields|
        fields.merge!(
          target: enum?(string, array(string)),
          ext: string?,
          "rc-path": string?,
          "ignore-path": string?,
          use: enum?(string, array(string)),
        )
      }

      let :issue, object(
        severity: string,
      )
    end

    register_config_schema(name: :remark_lint, schema: Schema.runner_config)

    CONSTRAINTS = {
      "remark-cli" => Gem::Requirement.new(">= 7.0.0", "< 10.0.0").freeze,
    }.freeze

    DEFAULT_TARGET = ".".freeze
    DEFAULT_PRESET = "remark-preset-lint-sider".freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        npm_install: false
        target: [docs/]
        ext: "md,markdown"
        rc-path: config/.remarkrc
        ignore-path: config/.remarkignore
        use:
          - remark-lint-file-extension
          - remark-lint-no-heading-punctuation
      YAML
    end

    def analyzer_bin
      "remark"
    end

    def extract_version!(command, version_option = "--version", pattern: /remark-cli: (\d+\.\d+\.\d+)/)
      super
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
      _, stderr, _ = capture3(nodejs_analyzer_bin, *cli_options, *analysis_target)

      issues, errors = parse_result(stderr)

      if errors.empty?
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          issues.each { |i| result.add_issue(i) }
        end
      else
        errors.each { |e| trace_writer.error(e) }

        msg = "#{errors.size} error(s) reported. See the log for details."
        Results::Failure.new(guid: guid, analyzer: analyzer, message: msg)
      end
    end

    private

    def analysis_target
      Array(config_linter[:target] || DEFAULT_TARGET)
    end

    def option_ext
      config_linter[:ext].then { |v| v ? ["--ext", v] : [] }
    end

    def option_rc_path
      config_linter[:"rc-path"].then { |v| v ? ["--rc-path", v] : [] }
    end

    def option_ignore_path
      config_linter[:"ignore-path"].then { |v| v ? ["--ignore-path", v] : [] }
    end

    def option_use
      Array(config_linter[:use]).flat_map { |v| ["--use", v] }
    end

    # @see https://github.com/unifiedjs/unified-engine/blob/8.0.0/doc/configure.md
    def no_rc_files?
      Dir.glob("**/.remarkrc{,.*}", File::FNM_DOTMATCH, base: current_dir.to_path).empty?
    end

    # @see https://github.com/unifiedjs/unified-engine/blob/8.0.0/doc/configure.md
    def no_config_in_package_json?
      !(package_json_path.exist? && package_json.key?(:remarkConfig))
    end

    def use_default_preset?
      !config_linter[:"rc-path"] &&
        !config_linter[:setting] &&
        !config_linter[:use] &&
        !config_linter[:config] &&
        no_rc_files? &&
        no_config_in_package_json?
    end

    def default_preset
      use_default_preset? ? ["--use", DEFAULT_PRESET] : []
    end

    def cli_options
      [
        *option_ext,
        *option_rc_path,
        *option_ignore_path,
        *option_use,
        *default_preset,
        "--report", "vfile-reporter-json",
        "--no-color",
        "--no-stdout",
      ]
    end

    def parse_result(output)
      issues = []
      errors = []

      JSON.parse(output, symbolize_names: true).each do |file|
        path = relative_path(file[:path])

        file.fetch(:messages).each do |message|
          stack = message[:stack]
          reason = message[:reason]
          ruleId = message[:ruleId]

          if stack
            errors << "#{reason} (at `#{path}`; rule: #{ruleId || '<none>'})\n#{stack}"
          else
            # NOTE: When `fatal` is `true`, then `severity` is `error`.
            #
            # @see https://github.com/remarkjs/remark-lint/blob/7.0.0/packages/unified-lint-rule/index.js#L27
            # @see https://github.com/remarkjs/remark-lint/blob/7.0.0/doc/rules.md#configuration
            severity = message[:fatal] ? "error" : "warn"

            issues << Issue.new(
              path: path,
              location: message[:line]&.then { |line| Location.new(start_line: line, start_column: message[:column]) },
              id: ruleId,
              message: reason,
              object: {
                severity: severity,
              },
              schema: Schema.issue,
            )
          end
        end
      end

      [issues, errors]
    end
  end
end
