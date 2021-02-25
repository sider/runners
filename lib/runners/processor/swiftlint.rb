module Runners
  class Processor::Swiftlint < Processor
    include Swift

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                        ignore_warnings: boolean?,
                        path: string?,
                        config: string?,
                        lenient: boolean?,
                        'enable-all-rules': boolean?,
                        options: object?(
                          path: string?,
                          config: string?,
                          lenient: boolean?,
                          'enable-all-rules': boolean?
                        )
                      })
      }

      let :issue, object(
        severity: string,
      )
    end

    register_config_schema(name: :swiftlint, schema: Schema.runner_config)

    def self.config_example
      <<~'YAML'
        root_dir: project/
        ignore_warnings: true
        path: src/
        config: config/.swiftlint.yml
        lenient: true
        enable-all-rules: true
      YAML
    end

    def extract_version_option
      "version"
    end

    def setup
      add_warning_if_deprecated_options
      yield
    end

    def analyze(changes)
      # NOTE: This makes it impossible using rules like `unused_import`.
      #       But the `unused_import` rule is for the `swiftlint analyze` command, not `swiftlint lint`.
      #       So, it seems there should not be a big inconvenience.
      #
      # @see https://realm.github.io/SwiftLint/unused_import.html
      delete_unchanged_files changes, only: ["*.swift"]

      stdout, stderr, status = capture3(
        analyzer_bin,
        'lint',
        '--reporter', 'json',
        '--no-cache',
        *cli_path,
        *cli_config,
        *cli_lenient,
        *cli_enable_all_rules,
      )

      # HACK: SwiftLint sometimes exits with no output, so we need to check also the existence of `*.swift` files.
      if status.exitstatus == 1 && (stderr.include?("No lintable files found at paths:") || working_dir.glob("**/*.swift").empty?)
        return Results::Success.new(guid: guid, analyzer: analyzer)
      end

      stderr.match(/SwiftLint Configuration Error: Could not read file at path: (.+)\n/) do |m|
        path = m.captures.first or raise "Unexpected match data: #{m.inspect}"
        message = "SwiftLint Configuration Error: Could not read file at path: #{relative_path(path)}"
        return Results::Failure.new(guid: guid, message: message, analyzer: analyzer)
      end

      stderr.match(/Currently running SwiftLint .+ but configuration specified version .+\./) do |m|
        return Results::Failure.new(guid: guid, message: m.to_s, analyzer: analyzer)
      end

      Results::Success.new(guid: guid, analyzer: analyzer, issues: parse_result(stdout))
    end

    private

    def ignore_warnings?
      config_linter[:ignore_warnings]
    end

    def cli_path
      path = config_linter[:path] || config_linter.dig(:options, :path)
      path ? ["--path", "#{path}"] : []
    end

    def cli_config
      config = config_linter[:config] || config_linter.dig(:options, :config)
      config ? ["--config", "#{config}"] : []
    end

    def cli_lenient
      lenient = config_linter[:lenient] || config_linter.dig(:options, :lenient)
      lenient ? ["--lenient"] : []
    end

    def cli_enable_all_rules
      enable_all_rules = config_linter[:'enable-all-rules'] || config_linter.dig(:options, :'enable-all-rules')
      enable_all_rules ? ["--enable-all-rules"] : []
    end

    def parse_result(output)
      JSON.parse(output, symbolize_names: true).filter_map do |error|
        if ignore_warnings? && error[:severity] == 'Warning'
          nil
        else
          Issue.new(
            path: relative_path(error[:file]),
            location: Location.new(start_line: error[:line]),
            id: error[:rule_id],
            message: error[:reason],
            links: ["https://realm.github.io/SwiftLint/#{error[:rule_id]}.html"],
            object: {
              severity: error[:severity],
            },
            schema: Schema.issue,
          )
        end
      end
    end
  end
end
