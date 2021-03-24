module Runners
  class Processor::HamlLint < Processor
    include Ruby
    include RuboCopUtils

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, ruby(
        target: target,
        file: target, # deprecated
        include_linter: one_or_more_strings?,
        exclude_linter: one_or_more_strings?,
        exclude: one_or_more_strings?,
        config: string?,
        parallel: boolean?,
      )

      let :issue, object(
        severity: string?,
      )
    end

    register_config_schema SCHEMA.config

    Config.register_warnings do |config|
      config.add_warning_for_deprecated_option(analyzer: analyzer_id, old: :file, new: :target)
    end

    GEM_NAME = "haml_lint".freeze
    REQUIRED_GEM_NAMES = ["rubocop"].freeze
    CONSTRAINTS = {
      GEM_NAME => Gem::Requirement.new(">= 0.26.0", "< 1.0.0").freeze,
    }.freeze
    DEFAULT_TARGET = ".".freeze
    DEFAULT_CONFIG_FILE = (Pathname(Dir.home) / "sider_recommended_haml_lint.yml").to_path.freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        gems:
          - { name: rubocop, version: 1.0.0 }
        target: [app/, lib/]
        include_linter:
          - EmptyScript
          - MultilinePipe
        exclude_linter:
          - TagName
        config: config/.haml-lint.yml
        parallel: false
      YAML
    end

    def analyzer_bin
      "haml-lint"
    end

    def setup
      setup_haml_lint_config

      default_gems = default_gem_specs(GEM_NAME, *REQUIRED_GEM_NAMES)
      if setup_default_rubocop_config
        # NOTE: See rubocop.rb about no versions.
        default_gems << GemInstaller::Spec.new("meowcop")
      end

      optionals = official_rubocop_plugins + third_party_rubocop_plugins
      install_gems(default_gems, optionals: optionals, constraints: CONSTRAINTS) { yield }
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(_changes)
      cmd = ruby_analyzer_command(
        "--reporter", "json",
        *include_linter,
        *exclude_linter,
        *exclude,
        *haml_lint_config,
        *config_parallel,
        *target,
      )
      stdout, stderr, status = capture3(cmd.bin, *cmd.args)

      # @see https://github.com/sds/haml-lint/blob/v0.35.0/lib/haml_lint/cli.rb#L110
      # @see https://github.com/ged/sysexits/blob/v1.2.0/lib/sysexits.rb#L96
      unless [65, 0].include?(status.exitstatus)
        return Results::Failure.new(guid: guid, analyzer: analyzer)
      end

      add_rubocop_warnings_if_exists(stderr)

      Results::Success.new(guid: guid, analyzer: analyzer, issues: parse_result(stdout))
    end

    private

    def setup_haml_lint_config
      return unless haml_lint_config.empty?

      path = current_dir / ".haml-lint.yml"
      return if path.exist?

      FileUtils.copy_file DEFAULT_CONFIG_FILE, path
      trace_writer.message "Set up the default #{analyzer_name} configuration file."
    end

    def target
      Array(config_linter[:target] || config_linter[:file] || DEFAULT_TARGET)
    end

    def include_linter
      value = comma_separated_list(config_linter[:include_linter])
      value ? ["--include-linter", value] : []
    end

    def exclude_linter
      value = comma_separated_list(config_linter[:exclude_linter])
      value ? ["--exclude-linter", value] : []
    end

    def exclude
      value = comma_separated_list(config_linter[:exclude])
      value ? ["--exclude", value] : []
    end

    def haml_lint_config
      config = config_linter[:config]
      config ? ["--config", config] : []
    end

    def config_parallel
      minimum_version = "0.36.0"
      if Gem::Version.new(analyzer_version) >= Gem::Version.new(minimum_version)
        parallel = config_linter[:parallel]
        if parallel == true || parallel.nil?
          return ["--parallel"]
        end
      elsif config_linter[:parallel] == true
        add_warning "The option `#{config_field_path(:parallel)}` is ignored with #{analyzer_name} #{analyzer_version}. Please update it to **#{minimum_version}+** or use our default version.",
                    file: config.path_name
      end

      []
    end

    def parse_result(output)
      JSON.parse(output, symbolize_names: true).fetch(:files).flat_map do |file|
        path = file.fetch(:path)
        file.fetch(:offenses).map do |offense|
          id = offense[:linter_name]
          message = offense.fetch(:message)
          line = offense.dig(:location, :line)
          cop_name = id == "RuboCop" ? extract_cop_name(message) : nil

          Issue.new(
            path: relative_path(path),
            location: line == 0 ? nil : Location.new(start_line: line),
            id: cop_name ? "RuboCop:#{cop_name}" : id,
            message: message,
            links: build_links(id, cop_name),
            object: {
              severity: offense[:severity],
            },
            schema: SCHEMA.issue,
          )
        end
      end
    end

    def extract_cop_name(message)
      message.match(/\A(?<name>[\w\/]+): /)&.then { |m| m[:name] }
    end

    def build_links(issue_id, cop_name)
      # NOTE: Syntax errors are produced by HAML itself, not HAML-Lint.
      return [] if issue_id.nil? || issue_id == "Syntax"

      links = ["#{analyzer_github}/blob/v#{analyzer_version}/lib/haml_lint/linter##{issue_id.downcase}"]
      cop_name ? links + build_rubocop_links(cop_name) : links
    end

    # NOTE: HAML-Lint exits successfully even if RuboCop fails.
    #       The version 0.35.0 fixed the issue, but we continue to support older versions.
    #
    # @see https://github.com/sds/haml-lint/issues/317
    def add_rubocop_warnings_if_exists(stderr)
      stderr.scan(/\bcannot load such file -- [\w-]+\b/) do |message|
        if message.is_a? String
          add_warning message
        else
          raise "Unexpected message: #{message.inspect}"
        end
      end
    end
  end
end
