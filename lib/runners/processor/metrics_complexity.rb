module Runners
  class Processor::MetricsComplexity < Processor
    include Python

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :issue, object(
        CCN: integer,
      )
    end

    def analyzer_bin
      "lizard"
    end

    def analyze(changes)
      capture3!(analyzer_bin,
        '--xml',
        '--output_file', report_file,
        '.')

      file_issues = construct_file_issues(read_report_xml)

      Results::Success.new(guid: guid, analyzer: analyzer, issues: file_issues)
    end

    private

    def construct_file_issues(xml_root)
      issues = []

      xml_root.each_element('//cppncss/measure[@type="File"]/item') do |elem|
        filepath_attr = elem[:name] or raise "Required name: #{elem.inspect}"
        filepath = relative_path(filepath_attr)

        ccn_text = elem.elements[3]&.text or raise "Required text: #{elem.elements[3].inspect}"
        sum_of_CCN = Integer(ccn_text)

        functions_text = elem.elements[4]&.text or raise "Required text: #{elem.elements[4].inspect}"
        functions = Integer(functions_text)

        msg = "The sum of complexity of total #{functions} function(s) is #{sum_of_CCN}."

        issues << Issue.new(
          path: filepath,
          location: nil,
          id: "metrics_file-complexity",
          message: msg,
          object: {
            CCN: sum_of_CCN,
            },
          schema: Schema.issue,
          )
      end

      issues
    end
  end
end
