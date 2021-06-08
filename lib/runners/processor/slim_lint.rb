module Runners
  class Processor::SlimLint < Processor
    include Ruby
    include RuboCopUtils

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, ruby(
        target: target,
        config: string?,
      )

      let :issue, object(
        severity: string,
      )
    end

    register_config_schema SCHEMA.config

    GEM_NAME = "slim_lint".freeze
    REQUIRED_GEM_NAMES = ["rubocop"].freeze
    CONSTRAINTS = {
      GEM_NAME => Gem::Requirement.new(">= 0.21.1", "< 1.0.0").freeze,
    }.freeze
    DEFAULT_TARGET = ".".freeze
    DEFAULT_CONFIG_FILE = (Pathname(Dir.home) / "sider_recommended_slim_lint.yml").to_path.freeze
    MISSING_ID = "missing-ID".freeze

    # NOTE: Sass is often used with Slim.
    OPTIONAL_GEMS = [
      GemInstaller::Spec.new("sassc"),
    ].freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        dependencies:
          - { name: "rubocop", version: "1.0.0" }
        target: [app/views/]
        config: config/.slim-lint.yml
      YAML
    end

    def analyzer_bin
      "slim-lint"
    end

    def setup
      setup_slim_lint_config

      default_gems = default_gem_specs(GEM_NAME, *REQUIRED_GEM_NAMES)

      if setup_default_rubocop_config
        # NOTE: See `Processor::RuboCop` about no versions.
        default_gems << GemInstaller::Spec.new("meowcop")
      end

      optionals = official_rubocop_plugins + third_party_rubocop_plugins + OPTIONAL_GEMS
      install_gems(default_gems, optionals: optionals, constraints: CONSTRAINTS) { yield }
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message)
    end

    def analyze(_changes)
      cmd = ruby_analyzer_command(
        "--reporter=json",
        *(config_linter[:config].then { |config| config ? ["--config", config] : [] }),
        *Array(config_linter[:target] || DEFAULT_TARGET),
      )

      stdout, stderr, status = capture3(cmd.bin, *cmd.args)

      # @see https://github.com/sds/slim-lint/blob/v0.21.1/lib/slim_lint/cli.rb#L11-L16
      case status.exitstatus
      when 0, 65
        Results::Success.new(guid: guid, analyzer: analyzer, issues: parse_result(stdout))
      when 67, 78
        Results::Failure.new(guid: guid, analyzer: analyzer, message: stdout.strip)
      else
        raise "#{stdout}\n#{stderr}"
      end
    end

    private

    def setup_slim_lint_config
      return if config_linter[:config]

      path = current_dir / ".slim-lint.yml"
      return if path.exist?

      FileUtils.copy_file DEFAULT_CONFIG_FILE, path
      trace_writer.message "Set up the default #{analyzer_name} configuration file."
    end

    def parse_result(output)
      JSON.parse(output, symbolize_names: true).fetch(:files).flat_map do |file|
        path = relative_path(file.fetch(:path))

        # @see https://github.com/sds/slim-lint/blob/v0.21.1/lib/slim_lint/reporter/json_reporter.rb#L42-L49
        file.fetch(:offenses).map do |offense|
          message = offense.fetch(:message)
          issue_id = build_id(offense.fetch(:linter), message)

          Issue.new(
            path: path,
            location: Location.new(start_line: offense.fetch(:location).fetch(:line)),
            id: issue_id,
            message: message,
            links: build_links(issue_id),
            object: {
              severity: offense.fetch(:severity),
            },
            schema: SCHEMA.issue,
          )
        end
      end
    end

    def build_id(id, message)
      case id
      when nil
        MISSING_ID
      when "RuboCop"
        cop = message.match(/\A(?<cop>\S+\/\S+): /) { |m| m[:cop] }
        cop ? "#{id}:#{cop}" : id
      else
        id
      end
    end

    def build_links(id)
      case id
      when nil, MISSING_ID
        []
      when /\ARuboCop:/
        cop_name = id.delete_prefix("RuboCop:")
        build_rubocop_links(cop_name) + ["#{analyzer_github}/blob/v#{analyzer_version}/lib/slim_lint/linter#rubocop"]
      else
        ["#{analyzer_github}/blob/v#{analyzer_version}/lib/slim_lint/linter##{id.downcase}"]
      end
    end
  end
end
