module Runners
  class Processor::Detekt < Processor
    include Java
    include Kotlin

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, java(
        baseline: string?,
        config: one_or_more_strings?,
        "config-resource": one_or_more_strings?,
        "disable-default-rulesets": boolean?,
        excludes: one_or_more_strings?,
        includes: one_or_more_strings?,
        target: target,
        input: target, # alias for `target`
        parallel: boolean?,
      )

      let :issue, object(
        severity: string
      )
    end

    register_config_schema(name: :detekt, schema: SCHEMA.config)

    def self.config_example
      <<~'YAML'
        root_dir: project/
        jvm_deps:
          - [com.example, detekt-rules, 1.0.0]
        baseline: config/detekt-baseline.xml
        config:
          - config/detekt-config.yml
        config-resource:
          - /detekt-config-on-classpath.yml
        disable-default-rulesets: true
        excludes:
          - "**/vendor/**"
        includes:
          - "**/important/**"
        target:
          - src/
          - test/
        parallel: true
      YAML
    end

    def setup
      begin
        install_jvm_deps
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message)
      end

      yield
    end

    def analyze(changes)
      delete_unchanged_files changes, only: kotlin_file_extensions

      _stdout, stderr, status = capture3(
        analyzer_bin,
        "--report", "xml:#{report_file}",
        *(config_linter[:baseline].then { |value| value ? ["--baseline", value] : [] }),
        *(comma_separated_list(config_linter[:config]).then { |list| list ? ["--config", list] : [] }),
        *(comma_separated_list(config_linter[:"config-resource"]).then { |list| list ? ["--config-resource", list] : [] }),
        *(config_linter[:"disable-default-rulesets"] ? ["--disable-default-rulesets"] : []),
        *(config_linter[:parallel] ? ["--parallel"] : []),
        *(comma_separated_list(config_linter[:excludes]).then { |list| list ? ["--excludes", list] : [] }),
        *(comma_separated_list(config_linter[:includes]).then { |list| list ? ["--includes", list] : [] }),
        *(comma_separated_list(config_linter[:target] || config_linter[:input]).then { |list| list ? ["--input", list] : []}),
      )

      # detekt has some exit codes.
      # @see https://detekt.github.io/detekt/cli.html
      case status.exitstatus
      when 0, 2
        Results::Success.new(guid: guid, analyzer: analyzer, issues: parse_output)
      when 3 # invalid configuration
        Results::Failure.new(guid: guid, message: "Your detekt configuration is invalid", analyzer: analyzer)
      else
        raise stderr
      end
    end

    private

    def parse_output
      issues = []

      read_report_xml.each_element("file") do |file|
        filename = file[:name] or raise "Required name: #{file.inspect}"
        path = relative_path(filename)

        file.each_element do |error|
          id = error[:source] or raise "Required ID: #{error.inspect}"
          message = error[:message] or raise "Required message: #{error.inspect}"

          case error.name
          when "error"
            issues << Issue.new(
              path: path,
              location: Location.new(start_line: error[:line], start_column: error[:column]),
              id: id,
              message: message,
              object: { severity: error[:severity] },
              schema: SCHEMA.issue
            )
          else
            warning = error.text or raise "Required text: #{error.inspect}"
            add_warning warning, file: path.to_path
          end
        end
      end

      issues
    end
  end
end
