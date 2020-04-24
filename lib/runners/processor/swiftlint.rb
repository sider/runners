module Runners
  class Processor::Swiftlint < Processor
    include Swift

    Schema = StrongJSON.new do
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

    def analyzer_version
      @analyzer_version ||= extract_version! analyzer_bin, 'version'
    end

    def setup
      add_warning_if_deprecated_options([:options])
      yield
    end

    def analyze(_changes)
      run_analyzer
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
        next if ignore_warnings? && error[:severity] == 'Warning'

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

    def run_analyzer
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

      begin
        json_result = parse_result(stdout)
      rescue JSON::ParserError
        message = "SwiftLint unexpectedly failed. Please see the log for details."
        return Results::Failure.new(guid: guid, message: message, analyzer: analyzer)
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        json_result.each { |v| result.add_issue(v) }
      end
    end
  end
end
