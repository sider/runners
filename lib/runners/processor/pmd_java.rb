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

      if status.success? || status.exitstatus == 4
        stderr.each_line do |line|
          case line
          when /WARNING: This analysis could be faster, please consider using Incremental Analysis/
            # We cannot support "incremental analysis" for now. So, ignore it.
          when /WARNING: (.+)$/
            add_warning $1
          end
        end

        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          xml = read_report_xml
          construct_result(xml) { |issue| result.add_issue(issue) }
        end
      else
        Results::Failure.new(guid: guid, analyzer: analyzer)
      end
    end

    private

    def cli_args
      [].tap do |args|
        args << "-language" << "java"
        args << "-threads" << "2"
        args << "-format" << "xml"
        args << "-reportfile" << report_file
        args << "-dir" << dir
        args << "-rulesets" << rulesets.join(",")
        min_priority&.tap { |num| args << "-minimumpriority" << num }
        encoding&.tap { |enc| args << "-encoding" << enc }
      end
    end

    def construct_result(xml)
      # https://github.com/pmd/pmd.github.io/blob/8b0c31ff8e18215ed213b7df400af27b9137ee67/report_2_0_0.xsd

      xml.each_element do |element|
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

    def rulesets
      Array(config_linter[:rulesets] || DEFAULT_RULESET)
    end

    def dir
      config_linter[:dir] || DEFAULT_DIR
    end

    def encoding
      config_linter[:encoding]
    end

    def min_priority
      config_linter[:min_priority]
    end
  end
end
