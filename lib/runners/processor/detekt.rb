module Runners
  class Processor::Detekt < Processor
    include Java

    Schema = StrongJSON.new do

      let :report_ids, enum(
        literal("xml"),
        literal("txt"),
        literal("html")
      )

      let :cli_config, object(
        baseline: string?,
        classpath: array?(string),
        config: array?(string),
        "config-resource": array?(string),
        "disable-default-rulesets": boolean?,
        excludes: array?(string),
        includes: array?(string),
        input: array?(string),
        "language-version": number?,
        plugins: array?(string)
      )

      let :gradle_config, object(
        task: string,
        report_id: report_ids,
        report_path: string
      )

      let :maven_config, object(
        phase: string,
        report_id: report_ids,
        report_path: string
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
      report_path = "detekt-report.xml"
      
      args = [
        cli_baseline,
        cli_classpath,
        cli_config_files,
        cli_config_resource,
        cli_disable_default_rulesets,
        cli_excludes,
        cli_input,
        cli_language_version,
        cli_plugins,
        cli_report(report_id, report_path)
      ].flatten.compact

      capture3(analyzer_bin, *args)
      construct_result(report_id, report_path)
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
      capture3("mvn", maven_config[:phase], *mvn_options)
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
      when "html"
        construct_html_result(output)
      when "xml"
        construct_checkstyle_result(output)
      when "txt"
        construct_plain_result(output)
      end
    end

    def construct_html_result(output)
      issues = []

      # NOTE: HTML that Detekt returns unable to parse..
      regexp_id = /<details id="(.*)" open=.*/
      regexp_detail = /<li><span class="location">(.*):(.*):(.*)<\/span><br><span class="message">(.*)<\/span>/
      
      rule = nil
      output.lines(chomp: true).map do |line|
        
        lrule = line.match(regexp_id)
        unless lrule.nil?
          rule, = lrule.captures
          next
        end

        ldetail = line.match(regexp_detail)
        unless ldetail.nil?
          file, start_line, _col, message = ldetail.captures
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
          else
            add_warning error.text.strip, file: file[:name]
          end
        end
      end

      issues
    end

    def construct_plain_result(output)
      issues = []

      regexp = /(.*) at (.*):(.*):(.*) - (.*)/

      output.lines(chomp: true).map do |line|
        match = line.match(regexp)

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
      unless cli_config[:baseline].nil?
        return check_user_file_exists(
          [cli_config[:baseline]],
          "baseline"
        )
      end
    end

    def cli_classpath
      unless cli_config[:classpath].empty?
        return check_user_file_exists(
          cli_config[:classpath],
          "classpath"
        )
      end
    end

    def cli_config_files
      unless cli_config[:config].empty?
        return check_user_file_exists(
          cli_config[:config],
          "config"
        )
      end
    end

    def cli_config_resource
      unless cli_config[:"config-resource"].empty?
        return check_user_file_exists(
          cli_config[:"config-resource"],
          "config-resource"
        )
      end
    end

    def cli_disable_default_rulesets
      "--disable-default-rulesets" if cli_config[:"disable-default-rulesets"]
    end

    def cli_excludes
      unless cli_config[:excludes].empty?
        return "--excludes", cli_config[:excludes].join(",")
      end
    end

    def cli_includes
      unless cli_config[:includes].empty?
        return "--includes", cli_config[:includes].join(",")
      end
    end

    def cli_input
      unless cli_config[:input].empty?
        return check_user_file_exists(
          cli_config[:input],
          "input"
        )
      end
    end

    def cli_language_version
      unless cli_config[:"language-version"].nil?
        return "--language-version", cli_config[:"language-version"].to_s
      end
    end

    def cli_plugins
      unless cli_config[:plugins].empty?
        return "--plugins", cli_config[:plugins].join(",")
      end
    end

    def cli_report(report_id, report_path)
      output_file_path = current_dir / report_path
      return "--report", "#{report_id}:#{output_file_path.to_path}"
    end

    def check_user_file_exists(paths, option_name)
      exists = []
      paths.each do |a_path|
        path = current_dir / a_path
        if path.exist?
          exists.push(a_path)
        end
      end

      unless exists.empty?
        return "--#{option_name}", exists.join(",")
      else
        msg = "Given '#{option_name}' path does not exist. Run without adding '--#{option_name}' option."
        trace_writer.message msg

        return nil
      end
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
              phase: config[:maven][:phase],
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
              classpath: Array(config[:cli][:classpath]) || [],
              config: Array(config[:cli][:config]) || [],
              "config-resource": config[:cli][:"config-resource"] || [],
              "disable-default-rulesets": config[:cli][:"disable-default-rulesets"] || false,
              excludes: Array(config[:cli][:excludes]) || [],
              includes: Array(config[:cli][:includes]) || [],
              input: Array(config[:cli][:input]) || [],
              "language-version": config[:cli][:"language-version"],
              plugins: Array(config[:cli][:plugins]) || []
            }
          }
        )
      else
        yield(
          {
            cli: {
              baseline: nil,
              classpath: [],
              config: [],
              "config-resource": [],
              "disable-default-rulesets": false,
              excludes: [],
              includes: [],
              input: [],
              "language-version": nil,
              plugins: []
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
