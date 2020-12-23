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
        '--verbose',
        '--csv',
        '--output_file', report_file,
        '.')

      function_issues = []
      read_report_csv(report_file, headers: true) do |row|
        function_issues << construct_function_issue(row)
      end

      file_issues = []
      function_issues
        .map { |issue| issue.path }
        .uniq
        .each do |filepath|
          file_issues << construct_file_issue(filepath, function_issues)
        end

      Results::Success.new(guid: guid, analyzer: analyzer, issues: file_issues)
    end

    private

    def construct_function_issue(row)
      # With --verbose and --csv flags, lizard writes results as following format:
      # NLOC,CCN,token,PARAM,length,location,file,function,long_name,start,end

      nloc = Integer(row["NLOC"])
      ccn = Integer(row["CCN"])
      function = row["function"]
      msg = "Complexity is #{ccn} for #{nloc} line(s) of code at #{function}."

      Issue.new(
        path: relative_path(row["file"]),
        location: Location.new(start_line: row["start"], end_line: row["end"]),
        id: "function-complexity",
        message: msg,
        object: {
          CCN: ccn,
          },
        schema: Schema.issue,
        )
    end

    def construct_file_issue(filepath, issues)
      issues_in_file = issues.select { |issue| issue.path == filepath }
      sum_of_CCN = issues_in_file.inject(0) { |sum, issue| sum + issue.object[:CCN] }
      msg = "The sum of complexity of total #{issues_in_file.length} function(s) is #{sum_of_CCN}."

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
