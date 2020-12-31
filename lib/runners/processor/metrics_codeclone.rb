module Runners
  class Processor::MetricsCodeClone < Processor
    include PmdCpdBase

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :issue, object(
        clones: integer,
      )
    end

    PmdCpdBase.register_config_schema(name: :metrics_codeclone)

    def analyze(changes)
      issues = run_analyze(changes)

      file_issues = []
      issues
        .map { |issue| issue.path }
        .uniq
        .each do |filepath|
          file_issues << construct_file_issue(issues, filepath)
        end

      Results::Success.new(guid: guid, analyzer: analyzer, issues: file_issues)
    end

    private

    def construct_file_issue(issues, filepath)
      issues_in_file = issues.select { |issue| issue.path == filepath }
      clones = issues_in_file.length
      sum_of_lines = issues_in_file.inject(0) { |sum, issue| sum + issue.object[:lines] }
      msg = "The number of code clones is #{clones} with total #{sum_of_lines} lines."

      Issue.new(
        path: filepath,
        location: nil,
        id: "metrics_code-clones",
        message: msg,
        object: {
          clones: clones,
          },
        schema: Schema.issue,
        )
    end
  end
end
