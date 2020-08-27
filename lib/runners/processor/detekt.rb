module Runners
  class Processor::Detekt < Processor
    include Java
    include Kotlin

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass
      let :runner_config, Runners::Schema::BaseConfig.java.update_fields { |fields|
        fields.merge!({
          baseline: string?,
          config: enum?(string, array(string)),
          "config-resource": enum?(string, array(string)),
          "disable-default-rulesets": boolean?,
          excludes: enum?(string, array(string)),
          includes: enum?(string, array(string)),
          input: enum?(string, array(string)),
        })
      }

      let :issue, object(
        severity: string
      )
    end

    register_config_schema(name: :detekt, schema: Schema.runner_config)

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
        *cli_baseline,
        *cli_config,
        *cli_config_resource,
        *cli_disable_default_rulesets,
        *cli_excludes,
        *cli_includes,
        *cli_input,
        *cli_report,
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

    def cli_baseline
      config_linter[:baseline].then { |value| value ? ["--baseline", value] : [] }
    end

    def cli_config
      Array(config_linter[:config]).then { |arr| arr.empty? ? [] : ["--config", arr.join(",")] }
    end

    def cli_config_resource
      Array(config_linter[:"config-resource"]).then { |arr| arr.empty? ? [] : ["--config-resource", arr.join(",")] }
    end

    def cli_disable_default_rulesets
      config_linter[:"disable-default-rulesets"] ? ["--disable-default-rulesets"] : []
    end

    def cli_excludes
      Array(config_linter[:excludes]).then { |arr| arr.empty? ? [] : ["--excludes", arr.join(",")] }
    end

    def cli_includes
      Array(config_linter[:includes]).then { |arr| arr.empty? ? [] : ["--includes", arr.join(",")] }
    end

    def cli_input
      Array(config_linter[:input]).then { |arr| arr.empty? ? [] : ["--input", arr.join(",")] }
    end

    def cli_report
      ["--report", "xml:#{report_file}"]
    end

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
              schema: Schema.issue
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
