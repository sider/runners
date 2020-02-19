module Runners
  class Processor::Detekt < Processor
    include Java
    require 'active_support/core_ext'

    Schema = StrongJSON.new do

      def self.array_or?(type)
        array = array(type)
        enum?(type, array, detector: -> (value) {
          case value
          when Array
            array
          else
            type
          end
        })
      end

      def self.array_or(type)
        array = array(type)

        enum(type, array, detector: -> (value) {
          case value
          when Array
            array
          else
            type
          end
        })
      end

      let :reporter, enum(
        literal("xml"),
        literal("txt"),
        literal("checkstyle")
      )

      let :cli_config, object(
        auto_correct: boolean?,
        baseline_path: string?,
        classpath: array?(string),
        config: array?(string),
        config_resource: array?(string),
        disable_default_rulesets: boolean?,
        excludes: array?(string),
        includes: array?(string),
        input: array?(string),
        language_version: number?,
        jvm_target: number?,
        plugins: array?(string),
        report_id: string?,
        report_path: string?
      )

      let :gradle_config, object(
        task: string,
        report_id: reporter,
        report_path: string?
      )

      let :maven_config, object(
        goal: string
      )

      let :cli, Schema::RunnerConfig.base.update_fields {|hash| hash[:cli] = cli_config}
      let :gradle, Schema::RunnerConfig.base.update_fields {|hash| hash[:gradle] = gradle_config}
      let :maven, Schema::RunnerConfig.base.update_fields {|hash| hash[:maven] = maven_config }
      let :base, Schema::RunnerConfig.base

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

    def analyzer_name
      'detekt'
    end

    def analyze(changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        delete_unchanged_files changes, only: [".kt", ".kts"]

        check_runner_config(config) do |checked_config|
          @detekt_config = checked_config

          issues = case
                   when gradle_config
                     run_gradle
                   when maven_config
                     run_maven
                   else
                     run_cli
                   end

          Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
            issues.each do |issue|
              result.add_issue issue
            end
            trace_writer.message "*********************analyze"
            trace_writer.message result.to_yaml
            trace_writer.message "*********************analyze"
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
          extract_detekt_version_for_maven(current_dir) || unknown_version
        when cli_config
          pom_dir = Pathname(ENV['RUNNER_USER_HOME']) / analyzer_name
          extract_detekt_version_for_maven(pom_dir) || unknown_version
        else
          unknown_version
        end
    end

    def self.ci_config_section_name
      'detekt'
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
      args = []

      if cli_config[:auto_correct]
        args.push("--auto-correct")
      end

      unless cli_config[:baseline_path].nil?
        args = check_user_file_exists(
          [cli_config[:baseline_path]],
          "baseline",
          args
        )
      end

      unless cli_config[:classpath].empty?
        args = check_user_file_exists(
          cli_config[:classpath],
          "classpath",
          args
        )
      end

      unless cli_config[:config].empty?
        args = check_user_file_exists(
          cli_config[:config],
          "config",
          args
        )
      end

      unless cli_config[:config_resource].empty?
        args = check_user_file_exists(
          cli_config[:config_resource],
          "config_resource",
          args
        )
      end

      if cli_config[:disable_default_rulesets]
        args.push("--disable-default-rulesets")
      end

      unless cli_config[:excludes].empty?
        args.push("--excludes", cli_config[:excludes].join(","))
      end

      unless cli_config[:includes].empty?
        args.push("--includes", cli_config[:includes].join(","))
      end

      unless cli_config[:input].empty?
        args = check_user_file_exists(
          cli_config[:input],
          "input",
          args
        )
      end

      unless cli_config[:language_version].nil?
        args.push("--language-version", cli_config[:language_version].to_s)
      end

      unless cli_config[:jvm_target].nil?
        args.push("--jvm-target", cli_config[:jvm_target].to_s)
      end

      unless cli_config[:plugins].empty?
        args.push("--plugins", cli_config[:plugins].join(","))
      end

      report_id = cli_config[:report_id]
      report_path = cli_config[:report_path]
      output_file_path = current_dir / report_path
      args.push("--report", "#{report_id}:#{output_file_path.to_path}")

      capture3(analyzer_bin, *args)

      if output_file_path.exist?
        trace_writer.message "Reading output from #{report_path}..."
        output = output_file_path.read
      else
        msg = "#{report_path} does not exist because an unexpected error occurred!"
        trace_writer.error msg
        raise msg
      end

      construct_checkstyle_result(output)
    end

    def run_gradle
      stdout, = capture3("./gradlew", "--quiet", gradle_config[:task])

      if gradle_config[:report_id].nil? || gradle_config[:report_path].nil?
        return construct_plain_result(stdout, true)
      end

      output_file = current_dir / gradle_config[:report_path]
      if output_file.exist?
        trace_writer.message "Reading output from #{output_file}..."
        return construct_result(gradle_config[:report_id], output_file.read)
      else
        return construct_plain_result(stdout, true)
      end
    end

    def run_maven
      report_path, phase = check_maven_config()

      unless maven_config[:goal].nil?
        goal = maven_config[:goal]
      else
        goal = phase
      end

      mvn_options = %w[--quiet --batch-mode -Dmaven.test.skip=true -Dmaven.main.skip=true]

      # NOTE: `mvn` fails when issues are found, so we should not check the exit status.
      capture3("mvn", goal, *mvn_options)

      output_file_path = current_dir / report_path

      if output_file_path.exist?
        trace_writer.message "Reading output from #{report_path}..."
        output = output_file_path.read
      else
        msg = "#{report_path} does not exist because an unexpected error occurred!"
        trace_writer.error msg
        raise msg
      end

      # construct_result(maven_config[:reporter], output)
      construct_checkstyle_result(output)
    end

    def construct_result(reporter, output)
      case reporter
      when "json"
        construct_json_result(output)
      when "xml"
        construct_checkstyle_result(output)
      when "txt"
        construct_plain_result(output)
      end
    end

    def construct_json_result(output)
      json = JSON.parse(output, symbolize_names: true)

      # json = Hash.from_xml(output)

      trace_writer.message json.to_yaml

      json.flat_map do |hash|
        hash[:file].flat_map do |error|
          construct_issue(
            file: hash[:file],
            line: (error[:line]).to_i,
            message: error[:message],
            rule: error[:rule],
          )
        end
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
            issues << construct_issue(
              file: file[:name],
              line: error[:line],
              message: error[:message],
              rule: error[:source],
            )
          when "exception"
            add_warning error.text.strip, file: file[:name]
          end
        end
      end

      issues
    end

    def construct_plain_result(output, is_stdout = false)
      issues = []

      regex = /(.*) at (.*):(.*):(.*) - (.*)/
      if is_stdout
        regex = /.*\t(.*) at (.*):(.*):(.*)/
      end

      output.lines(chomp: true).map do |line|
        match = line.match(regex)

        unless match.nil?
          rule, file, start_line, col, message = match.captures

          if message.nil?
            message = rule + " at " + file + ":" + start_line + ":" + col
          end

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

    # TODO: column追加
    def construct_issue(file:, line:, message:, rule:)
      Issue.new(
        path: relative_path(working_dir.realpath / file, from: working_dir.realpath),
        location: Location.new(start_line: line),
        id: rule,
        message: message,
      )
    end

    def check_user_file_exists(paths, option_name, args)
      ret = args.dup
      exists = []

      paths.each do |a_path|
        path = current_dir / a_path
        if path.exist?
          exists.push(a_path)
        end
      end

      unless exists.empty?
        ret.push("--#{option_name}", exists.join(","))
      else
        msg = "Given '#{option_name}' does not exist. Run without adding '--#{option_name}' option."
        trace_writer.error msg
      end

      return ret
    end

    def check_maven_config()
      report_path = nil
      phase = "verify"

      pom_file = current_dir / "pom.xml"
      unless pom_file.exist?
        msg = "'pom.xml' does not exist. Processing cannot continue."
        trace_writer.error msg
        raise msg
      end
      
      pom = REXML::Document.new(pom_file.read)
      id = "detekt"
      fds = pom.get_elements("//project/build/plugins/plugin/executions/execution/id[text()='#{id}']").first
      unless fds.nil?
        dom_setting = fds.parent
        unless dom_setting.elements["phase"].nil?
          phase = dom_setting.elements["phase"]
        end

        fdsp = dom_setting.get_elements("//configuration/target/java/arg[@value='--report']").first
        unless fdsp.nil?
          dom_setting_report = fdsp.next_element.attribute("value").to_s.split(/:/)
          report_path = dom_setting_report[1]
        end
      end

      if report_path.nil?
        msg = "arg '--report' undefined on 'pom.xml'. Processing cannot continue."
        trace_writer.error msg
        raise msg
      end

      return report_path, phase
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
            }
          }
        )
      when config[:cli]
        yield(
          {
            cli: {
              auto_correct: config[:cli][:auto_correct] || false,
              baseline_path: config[:cli][:baseline_path],
              classpath: Array(config[:cli][:classpath]) || [],
              config: Array(config[:cli][:config]) || [],
              config_resource: config[:cli][:config_resource] || [],
              disable_default_rulesets: config[:cli][:disable_default_rulesets] || false,
              excludes: Array(config[:cli][:excludes]) || [],
              includes: Array(config[:cli][:includes]) || [],
              input: Array(config[:cli][:input]) || [],
              language_version: config[:cli][:language_version],
              jvm_target: config[:cli][:jvm_target],
              plugins: Array(config[:cli][:plugins]) || [],
              report_id: config[:cli][:report_id] || "xml",
              report_path: config[:cli][:report_path] || "detekt_cli_report.xml"
            }
          }
        )
      else
        yield(
          {
            cli: {
              auto_correct: false,
              baseline_path: nil,
              classpath: [],
              config: [],
              config_resource: [],
              disable_default_rulesets: false,
              excludes: [],
              includes: [],
              input: [],
              language_version: nil,
              jvm_target: nil,
              plugins: [],
              report_id: "xml",
              report_path: "detekt_cli_report.xml"
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

    def extract_detekt_version_for_maven(pom_dir)
      pom_file = pom_dir / "pom.xml"
      return unless pom_file.exist?

      groupId = "io.gitlab.arturbosch.detekt"
      artifactId = "detekt-cli"
      pom = REXML::Document.new(pom_file.read)
      pom.root.each_element("//dependency/groupId[text()='#{groupId}']") do |element|
        dependency = element.parent
        if dependency.elements["artifactId"].text == artifactId
          return dependency.elements["version"].text
        end
      end
    end

  end
end
