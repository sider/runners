require "etc"

module Runners
  class Processor::Lizard < Processor
    include Python

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base

      let :issue, object(
        CCN: integer,
        )
    end

    register_config_schema(name: :lizard, schema: Schema.runner_config)

    def analyze(changes)
      capture3!(analyzer_bin,
        '--working_threads', Etc.nprocessors.to_s,
        '--xml',
        '--output_file', report_file,
        '.')

      file_issues = []
      read_report_xml.each_element('//cppncss/measure[@type="File"]/item') do |elem|
        file_issues << construct_file_issue(elem)
      end

      Results::Success.new(guid: guid, analyzer: analyzer, issues: file_issues)
    end

    private

    def construct_file_issue(elem)
      filepath = relative_path(elem.attributes['name'])
      sum_of_CCN = Integer(elem.elements[3].text)
      functions = Integer(elem.elements[4].text)
      msg = "The sum of complexity of total #{functions} function(s) is #{sum_of_CCN}."

      Issue.new(
        path: filepath,
        location: Location.new(start_line: 1),
        id: "metrics_file-complexity",
        message: msg,
        object: {
          CCN: sum_of_CCN,
          },
        schema: Schema.issue,
        )
    end
  end
end
