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
    end

    register_config_schema(name: :swiftlint, schema: Schema.runner_config)

    def self.ci_config_section_name
      'swiftlint'
    end

    def analyzer_version
      @analyzer_version ||= extract_version! analyzer_bin, 'version'
    end

    def analyzer_name
      'swiftlint'
    end

    def setup
      add_warning_if_deprecated_options([:options], doc: "https://help.sider.review/tools/swift/swiftlint")
      yield
    end

    def analyze(_changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        check_runner_config(config) do |ignore_warnings, options|
          run_analyzer(ignore_warnings, options)
        end
      end
    end

    def check_runner_config(config)
      # Sider option.
      ignore_warnings = ignore_warnings(config)

      # Command line options.
      path = path(config)
      swiftlint_config = swiftlint_config(config)
      lenient = lenient(config)
      enable_all_rules = enable_all_rules(config)

      options = [path, swiftlint_config, lenient, enable_all_rules].compact.flatten
      yield ignore_warnings, options
    end

    def ignore_warnings(config)
      config[:ignore_warnings] || false
    end

    def path(config)
      path = config[:path] || config.dig(:options, :path)
      ["--path", "#{path}"] if path
    end

    def swiftlint_config(config)
      config = config[:config] || config.dig(:options, :config)
      ["--config", "#{config}"] if config
    end

    def lenient(config)
      lenient = config[:lenient] || config.dig(:options, :lenient)
      "--lenient" if lenient
    end

    def enable_all_rules(config)
      enable_all_rules = config[:'enable-all-rules'] || config.dig(:options, :'enable-all-rules')
      "--enable-all-rules" if enable_all_rules
    end

    def parse_result(stdout, ignore_warnings)
      JSON.parse(stdout).map do |error|
        start_line = error['line']
        message = error['reason']
        id = error['rule_id']
        fname = error['file']

        next if ignore_warnings && error['severity'] == 'Warning'

        loc = Location.new(
          start_line: start_line,
          start_column: nil,
          end_line: nil,
          end_column: nil
        )
        Issue.new(
          path: relative_path(fname),
          location: loc,
          id: id,
          message: message,
        )
      end.compact
    end

    def run_analyzer(ignore_warnings, options)
      stdout, stderr, status = capture3(
        analyzer_bin,
        'lint',
        '--reporter', 'json',
        *options,
      )

      # https://github.com/realm/SwiftLint/pull/584
      # 0: No errors, maybe warnings in non-strict mode
      # 1: Usage or system error
      # 2: Style violations of severity "Error"
      # 3: No style violations of severity "Error", but violations of severity "warning" with --strict
      #
      # Otherwise it may be aborted.
      exitstatus = status.exitstatus

      # HACK: SwiftLint sometimes exits with no output, so we need to check also the existence of `*.swift` files.
      if exitstatus == 1 && (stderr.include?("No lintable files found at paths:") || Dir.glob("**/*.swift").empty?)
        add_warning "No lintable files found."
        return Results::Success.new(guid: guid, analyzer: analyzer)
      end

      unless [0, 2, 3].include?(exitstatus)
        summary = if exitstatus
                    "SwiftLint exited with unexpected status #{exitstatus}."
                  else
                    "SwiftLint aborted."
                  end
        return Results::Failure.new(guid: guid, message: <<~TEXT.strip, analyzer: analyzer)
          #{summary}

          #{stderr}
        TEXT
      end

      begin
        json_result = parse_result(stdout, ignore_warnings)
      rescue JSON::ParserError
        # For example, when setting wrong `swiftlint_version` in `.swiftlint.yml`.
        #
        # @see https://github.com/realm/SwiftLint/pull/2491
        return Results::Failure.new(guid: guid, message: stderr.strip, analyzer: analyzer)
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        json_result.each { |v| result.add_issue(v) }
      end
    end
  end
end
