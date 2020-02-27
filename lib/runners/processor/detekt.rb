module Runners
  class Processor::Detekt < Processor
    include Java

    Schema = StrongJSON.new do

      let :report_ids, enum(
        literal("xml"),
        literal("txt")
      )

      let :cli_config, object(
        baseline: string?,
        config: enum?(string, array(string)),
        "config-resource": enum?(string, array(string)),
        "disable-default-rulesets": boolean?,
        excludes: enum?(string, array(string)),
        includes: enum?(string, array(string)),
        input: enum?(string, array(string)),
      )

      let :gradle_config, object(
        task: string,
        report_id: report_ids,
        report_path: string
      )

      let :maven_config, object(
        goal: string,
        report_id: report_ids,
        report_path: string
      )

      let :cli, Schema::BaseConfig.base.update_fields {|hash| hash[:cli] = cli_config}
      let :gradle, Schema::BaseConfig.base.update_fields {|hash| hash[:gradle] = gradle_config}
      let :maven, Schema::BaseConfig.base.update_fields {|hash| hash[:maven] = maven_config }
      let :base, Schema::BaseConfig.base

      let :runner_config, enum(
        cli, gradle, maven, base,
        detector: -> (value) {
          case
          when value.key?(:cli)
            cli
          when value.key?(:gradle)
            gradle
          when value.key?(:maven)
            maven
          else
            base
          end
        }
      )
    end

    def self.ci_config_section_name
      'detekt'
    end

    def analyzer_name
      'detekt'
    end

    def analyze(changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        delete_unchanged_files changes, only: [".kt", ".kts"]

        check_runner_config(config) do |checked_config|
          @detekt_config = checked_config

          response = 
            case
            when gradle_config
              run_gradle
            when maven_config
              run_maven
            else
              run_cli
            end

          if response.kind_of?(Results::Failure)
            return response
          end
          
          Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
            response.each do |issue|
              result.add_issue issue
            end
          end
        end
      end
    end

    def analyzer_version
      unknown_version = "0.0.0"

      @analyzer_version ||=
        case
        when gradle_config
          extract_detekt_version_for_gradle || unknown_version
        when maven_config
          extract_detekt_version_for_maven || unknown_version
        else
          pom_dir = Pathname(ENV['RUNNER_USER_HOME']) / analyzer_name
          extract_detekt_version_for_maven(pom_dir) || unknown_version
        end
    end

    def detekt_config
      @detekt_config
    end

    def cli_config
      detekt_config[:cli]
    end

    def gradle_config
      detekt_config[:gradle]
    end

    def maven_config
      detekt_config[:maven]
    end

    def run_cli
      report_id = "xml"
      report_path = Tempfile.new("detekt-report")
      
      args = [
        cli_baseline,
        cli_config_files,
        cli_config_resource,
        cli_disable_default_rulesets,
        cli_excludes,
        cli_input,
        cli_report(report_id, report_path.path)
      ].flatten.compact

      _stdout, stderr, status = capture3(analyzer_bin, *args)

      # detekt has some exit codes.
      # @see https://github.com/arturbosch/detekt/blob/1.6.0/docs/pages/gettingstarted/cli.md
      case status.exitstatus
      when 0, 2
        construct_result(report_id, report_path)
      when 3 # invalid configuration
        Results::Failure.new(guid: guid, message: "Your detekt configuration is invalid", analyzer: analyzer)
      else
        trace_writer.error stderr.strip
        raise stderr
      end
    end

    def run_gradle
      capture3("./gradlew", "--quiet", gradle_config[:task])
      construct_result( 
        gradle_config[:report_id],
        gradle_config[:report_path]
      )
    end

    def run_maven
      mvn_options = %w[--quiet --batch-mode -Dmaven.test.skip=true -Dmaven.main.skip=true]
      capture3("mvn", maven_config[:goal], *mvn_options)
      construct_result(
        maven_config[:report_id],
        maven_config[:report_path]
      )
    end

    def construct_result(report_id, report_path)
      output_file_path = current_dir / report_path
      if output_file_path.exist?
        trace_writer.message "Reading output from #{report_path}..."
        output = output_file_path.read
      else
        msg = "#{report_path} does not exist. Unexpected error occurred, processing cannot continue."
        trace_writer.error msg
        raise msg
      end

      switch_constructor(report_id, output)
    end

    def switch_constructor(report_id, output)
      case report_id
      when "xml"
        construct_checkstyle_result(output)
      when "txt"
        construct_plain_result(output)
      end
    end

    def construct_checkstyle_result(output)
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
            regexp = /.*\.(.*)/
            rule, = error[:source].match(regexp).captures

            issues << construct_issue(
              file: file[:name],
              line: error[:line],
              message: error[:message],
              rule: rule,
            )
          else
            add_warning error.text.strip, file: file[:name]
          end
        end
      end

      issues
    end

    def construct_plain_result(output)
      issues = []

      regexp_a = /(.*) - .* - .* at (.*):(.*):(.*) - (.*)/
      regexp_b = /(.*) - .* at (.*):(.*):(.*) - (.*)/
      
      output.lines(chomp: true).map do |line|
        match = line.match(regexp_a)
        if match.nil?
          match = line.match(regexp_b)
        end

        unless match.nil?
          rule, file, start_line, _, message = match.captures
          issues << construct_issue(
            file: file,
            line: start_line,
            message: message,
            rule: rule,
          )
        end
      end

      issues
    end

    def construct_issue(file:, line:, message:, rule:)
      Issue.new(
        path: relative_path(working_dir.realpath / file, from: working_dir.realpath),
        location: Location.new(start_line: line),
        id: rule,
        message: message,
      )
    end

    def cli_baseline
      cli_config[:baseline].then { |value| value ? ["--baseline", value] : [] }
    end

    def cli_config_files
      cli_config[:config].then { |value| value.present? ? ["--config", value.join(",")] : [] }      
    end

    def cli_config_resource
      cli_config[:"config-resource"].then { |value| value.present? ? ["--config-resource", value.join(",")] : [] }
    end

    def cli_disable_default_rulesets
      "--disable-default-rulesets" if cli_config[:"disable-default-rulesets"]
    end

    def cli_excludes
      cli_config[:excludes].then { |value| value.present? ? ["--excludes", value.join(",")] : [] }
    end

    def cli_includes
      cli_config[:includes].then { |value| value.present? ? ["--includes", value.join(",")] : [] }
    end

    def cli_input
      cli_config[:input].then { |value| value.present? ? ["--input", value.join(",")] : [] }
    end

    def cli_report(report_id, report_path)
      ["--report", "#{report_id}:#{report_path}"]
    end

    def check_runner_config(config)
      case
      when config[:gradle]
        yield(
          {
            gradle: {
              task: config[:gradle][:task],
              report_id: config[:gradle][:report_id],
              report_path: config[:gradle][:report_path]
            }
          }
        )
      when config[:maven]
        yield(
          {
            maven: {
              goal: config[:maven][:goal],
              report_id: config[:maven][:report_id],
              report_path: config[:maven][:report_path]
            }
          }
        )
      when config[:cli]
        yield(
          {
            cli: {
              baseline: config[:cli][:baseline],
              config: Array(config[:cli][:config]) || [],
              "config-resource": config[:cli][:"config-resource"] || [],
              "disable-default-rulesets": config[:cli][:"disable-default-rulesets"] || false,
              excludes: Array(config[:cli][:excludes]) || [],
              includes: Array(config[:cli][:includes]) || [],
              input: Array(config[:cli][:input]) || []
            }
          }
        )
      else
        yield(
          {
            cli: {
              baseline: nil,
              config: [],
              "config-resource": [],
              "disable-default-rulesets": false,
              excludes: [],
              includes: [],
              input: []
            }
          }
        )
      end
    end

    def extract_detekt_version_for_gradle
      stdout, = capture3!("./gradlew", "--quiet", "dependencies")
      stdout.each_line do |line|
        line.match(/io\.gitlab\.arturbosch\.detekt:detekt-cli:([\d\.]+)/) do |match|
          return match.captures.first
        end
      end
    end

    def extract_detekt_version_for_maven(pom_dir = current_dir)
      pom_file = pom_dir / "pom.xml"
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

  end
end
