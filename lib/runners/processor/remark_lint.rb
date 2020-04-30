module Runners
  class Processor::RemarkLint < Processor
    include Nodejs

    Schema = StrongJSON.new do
      let(:runner_config, Schema::BaseConfig.npm.update_fields { |fields|
        fields.merge!(
          target: enum?(string, array(string)),
          ext: string?,
          "rc-path": string?,
          "ignore-path": string?,
          use: enum?(string, array(string)),
        )
      })
    end

    register_config_schema(name: :remark_lint, schema: Schema.runner_config)

    # NOTE: The `remark-lint` package is not always necessary,
    #       and only the `remark-cli` package is enough.
    DEFAULT_DEPS = DefaultDependencies.new(
      main: Dependency.new(name: "remark-cli", version: "8.0.0"),
    )

    CONSTRAINTS = {
      "remark-cli" => Constraint.new(">= 7.0.0", "< 9.0.0"),
    }.freeze

    DEFAULT_TARGET = ".".freeze
    DEFAULT_PRESET = "remark-preset-lint-sider".freeze

    def analyzer_bin
      "remark"
    end

    def extract_version!(command, version_option = "--version", pattern: /remark-cli: (\d+\.\d+\.\d+)/)
      super
    end

    def setup
      begin
        install_nodejs_deps(DEFAULT_DEPS, constraints: CONSTRAINTS, install_option: config_linter[:npm_install])
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
      end
      analyzer # Must initialize after installation
      yield
    end

    def analyze(_changes)
      run_analyzer
    end

    private

    def remark_lint_version!(global: false)
      pkg = "remark-lint"
      chdir = global ? Pathname(Dir.home).join(analyzer_id) : nil
      deps = list_installed_nodejs_deps only: [pkg], chdir: chdir
      deps.fetch(pkg).tap do |version|
        raise "No version of `#{pkg}`" if version.empty?
      end
    end

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

    # @see https://github.com/unifiedjs/unified-engine/blob/master/doc/configure.md
    def no_rc_files?
      Dir.glob("**/.remarkrc{,.*}", File::FNM_DOTMATCH, base: current_dir).empty?
    end

    # @see https://github.com/unifiedjs/unified-engine/blob/master/doc/configure.md
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

    def run_analyzer
      _, stderr, _ = capture3(nodejs_analyzer_bin, *cli_options, *analysis_target)

      issues, errors = parse_result(stderr)

      if errors.empty?
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          issues.each { |i| result.add_issue(i) }
        end
      else
        errors.each { |e| trace_writer.error(e) }

        msg = "#{errors.size} #{'error'.pluralize(errors.size)} reported. See the log for details."
        Results::Failure.new(guid: guid, analyzer: analyzer, message: msg)
      end
    end

    def parse_result(output)
      issues = []
      errors = []

      JSON.parse(output, symbolize_names: true).each do |file|
        path = relative_path(file[:path])

        file[:messages].each do |message|
          if message[:fatal]
            errors << "#{message[:reason]}\n#{message[:stack]}"
            next
          end

          issues << Issue.new(
            path: path,
            location: message[:line].then { |line| line ? Location.new(start_line: line) : nil },
            id: message[:ruleId],
            message: message[:reason],
          )
        end
      end

      [issues, errors]
    end
  end
end
