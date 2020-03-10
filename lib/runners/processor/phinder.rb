module Runners
  class Processor::Phinder < Processor
    include PHP

    DEFAULT_RULE_FILE = "phinder.yml".freeze
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                        rule: string?,
                        php: string?,
                      })
      }

      let :issue_object, object(
        id: string,
        message: string,
        justifications: array(string),
      )
    end

    register_config_schema(name: :phinder, schema: Schema.runner_config)

    def test_phinder_config
      args = []
      args.push("--config", config_linter[:rule]) if config_linter[:rule]

      _, stderr, status = capture3(analyzer_bin, "test", *args)

      # 0: Success (No configuration error & no test failure)
      # 1: Configuration error
      # 2: Test failure
      case status.exitstatus
      when 0
        # noop
      when 1
        # Skip other configuration errors.
        # These errors should be reported when running `phinder find`.
      when 2
        add_warning(<<~MESSAGE, file: config_linter[:rule] || DEFAULT_RULE_FILE)
          Phinder configuration validation failed.
          Check the following output by `phinder test` command.

          #{stderr}
        MESSAGE
      else
        raise <<~MESSAGE
          Phinder test was failed with status #{status.exitstatus} since an unexpected error occurred.
          STDERR:
          #{stderr}
        MESSAGE
      end
    end

    def run_phinder
      args = []
      args.push("--config", config_linter[:rule]) if config_linter[:rule]
      args << config_linter[:php] if config_linter[:php]

      stdout, stderr, status = capture3(analyzer_bin, "find", "-f", "json", *args)

      # 0: Success (No error & no violations are found)
      # 1: Error (Error & no violations are found)
      # 2: Violation (No error & violations are found)
      # 3: Error & Violation
      case status.exitstatus
      when 0
        Results::Success.new(guid: guid, analyzer: analyzer)
      when 2
        json = JSON.parse(stdout, symbolize_names: true)

        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          json[:result].each do |issue|
            result.add_issue Issue.new(
              id: issue[:rule][:id],
              path: relative_path(issue[:path]),
              location: Location.new(
                start_line: issue[:location][:start][0],
                start_column: issue[:location][:start][1],
                end_line: issue[:location][:end][0],
                end_column: issue[:location][:end][1],
              ),
              message: issue[:rule][:message],
              object: {
                id: issue[:rule][:id],
                message: issue[:rule][:message],
                justifications: Array(issue[:justifications]),
              },
              schema: Schema.issue_object,
            )
          end
        end
      when 1, 3
        json = JSON.parse(stdout, symbolize_names: true)
        # TODO: Handling violations?
        Results::Failure.new(guid: guid, message: <<~MESSAGE, analyzer: analyzer)
          #{json[:errors].size} #{"error".pluralize(json[:errors].size)} occurred:

          #{json[:errors].map { |error| "#{error[:type]}: #{error[:message]}" }.join("\n")}
        MESSAGE
      else
        raise <<~MESSAGE
          Phinder analysis was failed with status #{status.exitstatus} since an unexpected error occurred.
          STDERR:
          #{stderr}
        MESSAGE
      end
    end

    def analyze(changes)
      delete_unchanged_files(changes, except: ["*.yml", "*.yaml"])

      paths = []
      paths << relative_path(config_linter[:rule]) if config_linter[:rule]
      paths << relative_path(DEFAULT_RULE_FILE)
      ret = ensure_files(*paths) do
        test_phinder_config
        run_phinder
      end

      # NOTE: Exceptionally MissingFileFailure is treated as successful
      if ret.instance_of? Results::MissingFilesFailure
        trace_writer.error "File not found: #{paths.join(", ")}"
        add_warning(<<~MESSAGE, file: DEFAULT_RULE_FILE)
          Sider cannot find the required configuration file(s): `#{DEFAULT_RULE_FILE}`.
          Please set up Phinder by following the instructions, or you can disable it in the repository settings.

          - https://github.com/sider/phinder
          - #{analyzer_doc}
        MESSAGE
        Results::Success.new(guid: guid, analyzer: analyzer)
      else
        ret
      end
    end
  end
end
