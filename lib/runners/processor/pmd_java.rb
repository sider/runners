module Runners
  class Processor::PmdJava < Processor
    include Java

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.java.update_fields { |fields|
        fields.merge!({
          dir: string?,
          rulesets: enum?(string, array(string)),
          encoding: string?,
          min_priority: numeric?,
        })
      }

      let :issue, object(
        ruleset: string,
        priority: string,
      )
    end

    register_config_schema(name: :pmd_java, schema: Schema.runner_config)

    DEFAULT_RULESET = (Pathname(Dir.home) / "default-ruleset.xml").to_path.freeze
    DEFAULT_DIR = ".".freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        jvm_deps:
          - [my.company.com, pmd-ruleset, 1.2.3]
        dir: src/
        rulesets:
          - category/java/errorprone.xml
          - your_pmd_custom_rules.xml
        encoding: ISO-8859-1
        min_priority: 3
      YAML
    end

    def analyzer_version
      @analyzer_version ||= capture3!("show_pmd_version").yield_self { |stdout,| stdout.strip }
    end

    def analyzer_bin
      "pmd"
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
      delete_unchanged_files changes, only: ["*.java"]

      _, stderr, status = capture3(analyzer_bin, *cli_args)

      unless status.success?
        return Results::Failure.new(guid: guid, analyzer: analyzer)
      end

      stderr.each_line do |line|
        /WARNING: (.+)$/.match(line) do |m|
          msg = m[1] or raise m.inspect
          add_warning msg
        end
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        construct_result do |issue|
          result.add_issue(issue)
        end
      end
    end

    private

    def cli_args
      [
        "-language", "java",
        "-threads", "2",
        "-failOnViolation", "false",
        "-no-cache",
        "-format", "xml",
        "-reportfile", report_file,
        "-dir", (config_linter[:dir] || DEFAULT_DIR),
        "-rulesets", comma_separated_list(config_linter[:rulesets] || DEFAULT_RULESET),
        *(config_linter[:min_priority].then { |num| num ? ["-minimumpriority", num.to_s] : [] }),
        *(config_linter[:encoding].then { |enc| enc ? ["-encoding", enc] : [] }),
      ]
    end

    def construct_result
      # https://github.com/pmd/pmd.github.io/blob/8b0c31ff8e18215ed213b7df400af27b9137ee67/report_2_0_0.xsd

      read_report_xml.each_element do |element|
        case element.name
        when "file"
          filename = element[:name] or raise "Unexpected element: #{element.inspect}"
          path = relative_path(filename)

          element.each_element("violation") do |violation|
            message = violation.text or raise "required message: #{violation.inspect}"

            yield Issue.new(
              path: path,
              location: Location.new(
                start_line: violation[:beginline],
                start_column: violation[:begincolumn],
                end_line: violation[:endline],
                end_column: violation[:endcolumn],
              ),
              id: violation[:rule],
              message: message.strip,
              links: violation[:externalInfoUrl].then { |url| url ? [url] : [] },
              object: {
                ruleset: violation[:ruleset],
                priority: violation[:priority],
              },
              schema: Schema.issue,
            )
          end
        when "error"
          msg = element[:msg] or raise "Unexpected element: #{element.inspect}"
          filename = element[:filename] or raise "Unexpected element: #{element.inspect}"
          add_warning msg, file: relative_path(filename).to_path
        when "configerror"
          rule = element[:rule] or raise "Unexpected element: #{element.inspect}"
          msg = element[:msg] or raise "Unexpected element: #{element.inspect}"
          add_warning "#{rule}: #{msg}"
        end
      end
    end
  end
end
