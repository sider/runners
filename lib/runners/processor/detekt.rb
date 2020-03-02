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

    def self.ci_config_section_name
      'detekt'
    end

    def analyzer_version
      unknown_version = "0.0.0"
      @analyzer_version ||= extract_detekt_version || unknown_version
    end

    def extract_detekt_version
      pom_file = Pathname(Dir.home) / analyzer_name / "pom.xml"
      return unless pom_file.exist?

      group_id = "io.gitlab.arturbosch.detekt"
      artifact_id = "detekt-cli"
      pom = REXML::Document.new(pom_file.read)
      pom.root.each_element("//dependency/groupId[text()='#{group_id}']") do |element|
        dependency = element.parent
        if dependency.elements["artifactId"].text == artifact_id
          return dependency.elements["version"].text
        end
      end
    end

    def analyzer_name
      'detekt'
    end

    def detekt_config
      @detekt_config
    end

    def analyze(changes)
      delete_unchanged_files changes, only: [".kt", ".kts"]

      check_runner_config do |checked_config|
        @detekt_config = checked_config
        run_analyzer
      end
    end

    def check_runner_config
      yield(
        {
          baseline: ci_section[:baseline],
          config: Array(ci_section[:config]) || [],
          "config-resource": ci_section[:"config-resource"] || [],
          "disable-default-rulesets": ci_section[:"disable-default-rulesets"] || false,
          excludes: Array(ci_section[:excludes]) || [],
          includes: Array(ci_section[:includes]) || [],
          input: Array(ci_section[:input]) || []
        }
      )
    end

    def run_analyzer
      report_id = "xml"
      report_path = Tempfile.new("detekt-report").path

      args = [
        baseline,
        config_files,
        config_resource,
        disable_default_rulesets,
        excludes,
        input,
        report(report_id, report_path)
      ].flatten.compact

      _stdout, stderr, status = capture3(analyzer_bin, *args)

      # detekt has some exit codes.
      # @see https://github.com/arturbosch/detekt/blob/1.6.0/docs/pages/gettingstarted/cli.md
      case status.exitstatus
      when 0, 2
        issues = construct_result(report_path)
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

    def baseline
      detekt_config[:baseline].then { |value| value ? ["--baseline", value] : [] }
    end

    def config_files
      detekt_config[:config].then { |value| value.present? ? ["--config", value.join(",")] : [] }
    end

    def config_resource
      detekt_config[:"config-resource"].then { |value| value.present? ? ["--config-resource", value.join(",")] : [] }
    end

    def disable_default_rulesets
      detekt_config[:"disable-default-rulesets"] ? ["--disable-default-rulesets"] : []
    end

    def excludes
      detekt_config[:excludes].then { |value| value.present? ? ["--excludes", value.join(",")] : [] }
    end

    def includes
      detekt_config[:includes].then { |value| value.present? ? ["--includes", value.join(",")] : [] }
    end

    def input
      detekt_config[:input].then { |value| value.present? ? ["--input", value.join(",")] : [] }
    end

    def report(report_id, report_path)
      ["--report", "#{report_id}:#{report_path}"]
    end

    def construct_result(report_path)
      output_file_path = current_dir / report_path
      if output_file_path.exist?
        trace_writer.message "Reading output from #{report_path}..."
        output = output_file_path.read
        trace_writer.message output
      else
        msg = "#{report_path} does not exist. Unexpected error occurred, processing cannot continue."
        trace_writer.error msg
        raise msg
      end

      parse_output(output)
    end

    def parse_output(output)
      document = REXML::Document.new(output)
      unless document.root
        msg = "Invalid XML output!"
        trace_writer.error msg
        raise msg
      end

      issues = []
      document.root.each_element("file") do |file|
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
