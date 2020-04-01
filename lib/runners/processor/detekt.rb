module Runners
  class Processor::Detekt < Processor
    include Java

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!(
          {
            baseline: string?,
            config: enum?(string, array(string)),
            "config-resource": enum?(string, array(string)),
            "disable-default-rulesets": boolean?,
            excludes: enum?(string, array(string)),
            includes: enum?(string, array(string)),
            input: enum?(string, array(string)),
          }
        )
      }

      let :issue, object(
        severity: string
      )
    end

    register_config_schema(name: :detekt, schema: Schema.runner_config)

    def analyze(changes)
      delete_unchanged_files changes, only: [".kt", ".kts"]
      run_analyzer
    end

    private

    def run_analyzer
      report_path = Tempfile.create(["detekt-report-", ".xml"]).path

      _stdout, stderr, status = capture3(
        analyzer_bin,
        *cli_baseline,
        *cli_config,
        *cli_config_resource,
        *cli_disable_default_rulesets,
        *cli_excludes,
        *cli_includes,
        *cli_input,
        *cli_report(report_path),
      )

      # detekt has some exit codes.
      # @see https://github.com/arturbosch/detekt/blob/1.7.0/docs/pages/gettingstarted/cli.md
      case status.exitstatus
      when 0, 2
        issues = parse_output(report_path)
        return Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          issues.each do |issue|
            result.add_issue issue
          end
        end
      when 3 # invalid configuration
        return Results::Failure.new(guid: guid, message: "Your detekt configuration is invalid", analyzer: analyzer)
      else
        trace_writer.error stderr.strip
        raise stderr
      end
    end

    def cli_baseline
      config_linter[:baseline].then { |value| value ? ["--baseline", value] : [] }
    end

    def cli_config
      Array(config_linter[:config]).then { |arr| arr.present? ? ["--config", arr.join(",")] : [] }
    end

    def cli_config_resource
      Array(config_linter[:"config-resource"]).then { |arr| arr.present? ? ["--config-resource", arr.join(",")] : [] }
    end

    def cli_disable_default_rulesets
      config_linter[:"disable-default-rulesets"] ? ["--disable-default-rulesets"] : []
    end

    def cli_excludes
      Array(config_linter[:excludes]).then { |arr| arr.present? ? ["--excludes", arr.join(",")] : [] }
    end

    def cli_includes
      Array(config_linter[:includes]).then { |arr| arr.present? ? ["--includes", arr.join(",")] : [] }
    end

    def cli_input
      Array(config_linter[:input]).then { |arr| arr.present? ? ["--input", arr.join(",")] : [] }
    end

    def cli_report(report_path)
      ["--report", "xml:#{report_path}"]
    end

    def parse_output(output_path)
      issues = []

      read_output_xml(output_path).root.each_element("file") do |file|
        file.each_element do |error|
          case error.name
          when "error"
            issues << construct_issue(
              file: file[:name],
              line: error[:line],
              message: error[:message],
              rule: error[:source],
              severity: error[:severity]
            )
          else
            add_warning error.text.strip, file: file[:name]
          end
        end
      end

      issues
    end

    def construct_issue(file:, line:, message:, rule:, severity:)
      Issue.new(
        path: relative_path(file),
        location: Location.new(start_line: line),
        id: rule,
        message: message,
        object: { severity: severity },
        schema: Schema.issue
      )
    end
  end
end
