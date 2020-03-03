module Runners
  class Processor::ScssLint < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!(
          config: string?,
          # DO NOT ADD OPTIONS ANY MORE in `options`.
          options: object?(
            config: string?,
          )
        )
      }
    end

    register_config_schema(name: :scss_lint, schema: Schema.runner_config)

    # https://github.com/brigade/scss-lint#exit-status-codes
    EXIT_CODE_FILES_NOT_EXIST = 80

    def analyzer_bin
      'scss-lint'
    end

    def analyzer_version
      @analyzer_version ||= extract_version! analyzer_bin
    end

    def setup
      add_warning_if_deprecated_options([:options])
      yield
    end

    def analyze(_changes)
      options = [scss_lint_config].compact
      run_analyzer(options)
    end

    def scss_lint_config
      config = config_linter[:config] || config_linter.dig(:options, :config)
      "--config=#{config}" if config
    end

    # @param stdout [String]
    def parse_result(stdout)
      JSON.parse(stdout).flat_map do |file, issues|
        issues.map do |issue|
          line = issue['line']
          message = issue['reason']
          id = issue['linter']

          loc = Location.new(
            start_line: line,
            start_column: nil,
            end_line: nil,
            end_column: nil
          )
          Issue.new(
            path: relative_path(file),
            location: loc,
            id: id,
            message: message,
          )
        end
      end
    end

    def run_analyzer(options)
      stdout, stderr, status = capture3(analyzer_bin, '--format=JSON', *options)
      # https://github.com/brigade/scss-lint#exit-status-codes
      case status.exitstatus
      when 0..2
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          parse_result(stdout).each { |v| result.add_issue(v) }
        end
      when EXIT_CODE_FILES_NOT_EXIST
        # NOTE: If there are no analysis target files, returns `Success` with a warning.
        add_warning(stdout.chomp)
        Results::Success.new(guid: guid, analyzer: analyzer)
      else
        Results::Failure.new(guid: guid, message: <<~MESSAGE, analyzer: analyzer)
          stdout:
          #{stdout}

          stderr:
          #{stderr}
        MESSAGE
      end
    end
  end
end
