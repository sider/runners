module Runners
  class Processor::PmdJava < Processor
    include Java

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                        dir: string?,
                        rulesets: enum?(string, array(string)),
                        encoding: string?,
                        min_priority: numeric?
                      })
      }

      let :issue, object(
        ruleset: string,
        priority: string,
      )
    end

    register_config_schema(name: :pmd_java, schema: Schema.runner_config)

    def analyzer_version
      @analyzer_version ||= capture3!("show_pmd_version").yield_self { |stdout,| stdout.strip }
    end

    def analyzer_bin
      "pmd"
    end

    def analyze(changes)
      delete_unchanged_files changes, only: ["*.java"]

      run_analyzer
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
        min_priority&.tap { args << "-minimumpriority" << _1.to_s }
        encoding&.tap { args << "-encoding" << _1 }
      end
    end

    def run_analyzer
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
          construct_result(xml) { result.add_issue _1 }
        end
      else
        Results::Failure.new(guid: guid, analyzer: analyzer, message: "Unexpected error occurred. Please see the analysis log.")
      end
    end

    def construct_result(xml)
      # https://github.com/pmd/pmd.github.io/blob/8b0c31ff8e18215ed213b7df400af27b9137ee67/report_2_0_0.xsd

      xml.root.each_element do |element|
        case element.name
        when "file"
          path = relative_path(element[:name])

          element.each_element("violation") do |violation|
            yield Issue.new(
              path: path,
              location: Location.new(
                start_line: violation[:beginline],
                start_column: violation[:begincolumn],
                end_line: violation[:endline],
                end_column: violation[:endcolumn],
              ),
              id: violation[:rule],
              message: violation.text.strip,
              links: Array(violation[:externalInfoUrl]),
              object: {
                ruleset: violation[:ruleset],
                priority: violation[:priority],
              },
              schema: Schema.issue,
            )
          end
        when "error"
          add_warning element[:msg], file: relative_path(element[:filename]).to_s
        when "configerror"
          add_warning "#{element[:rule]}: #{element[:msg]}"
        end
      end
    end

    def rulesets
      Array(config_linter[:rulesets] || default_ruleset)
    end

    def default_ruleset
      (Pathname(Dir.home) / "default-ruleset.xml").realpath
    end

    def dir
      config_linter[:dir] || "."
    end

    def encoding
      config_linter[:encoding]
    end

    def min_priority
      config_linter[:min_priority]
    end
  end
end
