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
      add_warning_for_deprecated_linter(
        alternative: analyzers.name(:stylelint),
        ref: "https://github.com/sds/scss-lint/blob/master/README.md#notice-consider-other-tools-before-adopting-scss-lint",
      )

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
      JSON.parse(stdout, symbolize_names: true).flat_map do |file, issues|
        path = relative_path(file.to_s)
        issues.map do |issue|
          Issue.new(
            path: path,
            location: Location.new(start_line: issue[:line], start_column: issue[:column]),
            id: issue[:linter],
            message: issue[:reason],
          )
        end
      end
    end

    def run_analyzer(options)
      stdout, _stderr, status = capture3(analyzer_bin, '--format=JSON', *options)
      # https://github.com/brigade/scss-lint#exit-status-codes
      case status.exitstatus
      when 0..2
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          parse_result(stdout).each { |v| result.add_issue(v) }
        end
      when EXIT_CODE_FILES_NOT_EXIST
        # NOTE: If there are no analysis target files, returns `Success` with a warning.
        add_warning(stdout)
        Results::Success.new(guid: guid, analyzer: analyzer)
      else
        Results::Failure.new(guid: guid, analyzer: analyzer)
      end
    end
  end
end
