require_relative 'rubocop'

module Runners
  class Processor::HamlLint < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.ruby.update_fields { |fields|
        fields.merge!({
                        target: enum?(string, array(string)),
                        file: string?,
                        include_linter: enum?(string, array(string)),
                        exclude_linter: enum?(string, array(string)),
                        exclude: enum?(string, array(string)),
                        config: string?,
                        # DO NOT ADD ANY OPTION in `options` option.
                        options: object?(
                          file: string?,
                          include_linter: enum?(string, array(string)),
                          exclude_linter: enum?(string, array(string)),
                          exclude: enum?(string, array(string)),
                          config: string?
                        )
                      })
      }

      let :issue, object(
        severity: string?,
      )
    end

    register_config_schema(name: :haml_lint, schema: Schema.runner_config)

    OPTIONAL_GEMS = [
      *Processor::RuboCop::OPTIONAL_GEMS,
      # additional gems for HAML-Lint
    ].freeze

    DEFAULT_GEMS = ["haml_lint", "rubocop"].freeze

    CONSTRAINTS = {
      "haml_lint" => [">= 0.26.0", "< 1.0.0"]
    }.freeze

    DEFAULT_TARGET = ".".freeze
    DEFAULT_RUBOCOP_CONFIG = (Pathname(Dir.home) / 'default_rubocop.yml').to_path.freeze

    def analyzer_bin
      "haml-lint"
    end

    def default_gem_specs
      super(*DEFAULT_GEMS).tap do |gems|
        if setup_default_rubocop_config
          # NOTE: See rubocop.rb about no versions.
          gems << GemInstaller::Spec.new(name: "meowcop", version: [])
        end
      end
    end

    def setup
      add_warning_if_deprecated_options
      add_warning_for_deprecated_option :file, to: :target

      install_gems default_gem_specs, optionals: OPTIONAL_GEMS, constraints: CONSTRAINTS do
        yield
      end
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(_changes)
      run_analyzer
    end

    private

    def setup_default_rubocop_config
      config_file = ".rubocop.yml"
      return if File.exist? config_file

      FileUtils.cp(DEFAULT_RUBOCOP_CONFIG, config_file)
      config_file
    end

    def target
      Array(config_linter[:target] || config_linter[:file] ||
            config_linter.dig(:options, :file) || DEFAULT_TARGET)
    end

    def include_linter
      value = comma_separated_list(config_linter[:include_linter] || config_linter.dig(:options, :include_linter))
      value ? ["--include-linter", value] : []
    end

    def exclude_linter
      value = comma_separated_list(config_linter[:exclude_linter] || config_linter.dig(:options, :exclude_linter))
      value ? ["--exclude-linter", value] : []
    end

    def exclude
      value = comma_separated_list(config_linter[:exclude] || config_linter.dig(:options, :exclude))
      value ? ["--exclude", value] : []
    end

    def haml_lint_config
      config = config_linter[:config] || config_linter.dig(:options, :config)
      config ? ["--config", config] : []
    end

    def parse_result(output)
      JSON.parse(output, symbolize_names: true).fetch(:files).flat_map do |file|
        path = file.fetch(:path)
        file.fetch(:offenses).map do |offense|
          id = offense[:linter_name]
          message = offense[:message]
          line = offense.dig(:location, :line)

          Issue.new(
            path: relative_path(path),
            location: line == 0 ? nil : Location.new(start_line: line),
            id: id,
            message: message,
            links: build_links(id),
            object: {
              severity: offense[:severity],
            },
            schema: Schema.issue,
          )
        end
      end
    end

    def build_links(issue_id)
      # NOTE: Syntax errors are produced by HAML itself, not HAML-Lint.
      return [] if issue_id == "Syntax"

      ["https://github.com/sds/haml-lint/blob/v#{analyzer_version}/lib/haml_lint/linter##{issue_id.downcase}"]
    end

    def run_analyzer
      stdout, stderr, status = capture3(
        *ruby_analyzer_bin,
        "--reporter", "json",
        *include_linter,
        *exclude_linter,
        *exclude,
        *haml_lint_config,
        *target,
      )

      # @see https://github.com/sds/haml-lint/blob/v0.35.0/lib/haml_lint/cli.rb#L110
      # @see https://github.com/ged/sysexits/blob/v1.2.0/lib/sysexits.rb#L96
      unless [65, 0].include?(status.exitstatus)
        return Results::Failure.new(guid: guid, message: "HAML-Lint raises an unexpected error", analyzer: analyzer)
      end

      add_rubocop_warnings_if_exists(stderr)

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        parse_result(stdout).each { |v| result.add_issue(v) }
      end
    end

    # NOTE: HAML-Lint exits successfully even if RuboCop fails.
    #       The version 0.35.0 fixed the issue, but we continue to support older versions.
    #
    # @see https://github.com/sds/haml-lint/issues/317
    def add_rubocop_warnings_if_exists(stderr)
      stderr.scan(/\bcannot load such file -- [\w-]+\b/) do |message|
        add_warning message
      end
    end
  end
end
