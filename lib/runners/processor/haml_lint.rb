require_relative 'rubocop'

module Runners
  class Processor::HamlLint < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :runner_config, Schema::RunnerConfig.ruby.update_fields { |fields|
        fields.merge!({
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

    OPTIONAL_GEMS = [
      *Processor::RuboCop::OPTIONAL_GEMS,
      # additional gems for HAML-Lint
    ].freeze

    DEFAULT_GEMS = ["haml_lint", "rubocop"].freeze

    CONSTRAINTS = {
      "haml_lint" => [">= 0.26.0", "< 1.0.0"]
    }.freeze

    def self.ci_config_section_name
      'haml_lint'
    end

    def analyzer_bin
      "haml-lint"
    end

    def analyzer_name
      'haml_lint'
    end

    def default_gem_specs
      super(*DEFAULT_GEMS).tap do |gems|
        if setup_default_config
          # NOTE: See rubocop.rb about no versions.
          gems << GemInstaller::Spec.new(name: "meowcop", version: [])
        end
      end
    end

    def setup
      add_warning_if_deprecated_options([:options], doc: "https://help.sider.review/tools/ruby/haml-lint")

      ensure_runner_config_schema(Schema.runner_config) do
        install_gems default_gem_specs, optionals: OPTIONAL_GEMS, constraints: CONSTRAINTS do |versions|
          yield
        end
      end
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(_changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        check_runner_config(config) do |targets, options|
          run_analyzer(targets, options)
        end
      end
    end

    def setup_default_config
      # NOTE: We expect default_rubocop.yml to be located in $HOME.
      default_config = (Pathname(Dir.home) / './default_rubocop.yml').realpath
      path = Pathname("#{current_dir}/.rubocop.yml")
      return false if path.exist?
      path.parent.mkpath
      FileUtils.cp(default_config, path)
      true
    end

    def check_runner_config(config)
      # Option which has a default value.
      targets = file(config)

      # Additional option.
      include_linter = include_linter(config)
      exclude_linter = exclude_linter(config)
      exclude = exclude(config)
      haml_lint_config = haml_lint_config(config)

      options = [include_linter, exclude_linter, exclude, haml_lint_config].compact
      yield targets, options
    end

    def file(config)
      config[:file] || config.dig(:options, :file) || '.'
    end

    def include_linter(config)
      include_linter = config[:include_linter] || config.dig(:options, :include_linter)
      if include_linter
        "--include-linter=#{Array(include_linter).join(',')}"
      end
    end

    def exclude_linter(config)
      exclude_linter = config[:exclude_linter] || config.dig(:options, :exclude_linter)
      if exclude_linter
        "--exclude-linter=#{Array(exclude_linter).join(',')}"
      end
    end

    def exclude(config)
      exclude = config[:exclude] || config.dig(:options, :exclude)
      if exclude
        "--exclude=#{Array(exclude).join(',')}"
      end
    end

    def haml_lint_config(config)
      config = config[:config] || config.dig(:options, :config)
      "--config=#{config}" if config
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
            location: Location.new(start_line: line),
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

    def run_analyzer(targets, options)
      stdout, stderr, status = capture3(
        *ruby_analyzer_bin,
        targets,
        '--reporter',
        'json',
        *options,
      )

      # @see https://github.com/sds/haml-lint/blob/v0.34.2/lib/haml_lint/cli.rb#L110
      unless [65, 0].include?(status.exitstatus)
        return Results::Failure.new(guid: guid, message: <<~MESSAGE, analyzer: analyzer)
          stdout:
          #{stdout}

          stderr:
          #{stderr}
        MESSAGE
      end

      add_rubocop_warnings_if_exists(stderr)

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        parse_result(stdout).each { |v| result.add_issue(v) }
      end
    end

    # NOTE: HAML-Lint exits successfully even if RuboCop fails.
    #
    # @see https://github.com/sds/haml-lint/issues/317
    def add_rubocop_warnings_if_exists(stderr)
      stderr.scan(/\bcannot load such file -- [\w-]+\b/) do |message|
        add_warning message
      end
    end
  end
end
