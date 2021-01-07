module Runners
  class Processor::MetricsCodeClone < Processor

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :issue, object(
        clones: integer,
      )
    end

    def initialize(**params)
      super(**params)
      @pmd_cpd = PmdCpd.new(**params)
    end

    def config_linter
      @pmd_cpd.config_linter
    end

    def analyzer_bin
      @pmd_cpd.analyzer_bin
    end

    def analyzer_version
      @pmd_cpd.analyzer_version
    end

    def check_root_dir_exist
      @pmd_cpd.check_root_dir_exist
    end

    def analyze(changes)
      result = @pmd_cpd.analyze(changes)
      @pmd_cpd.warnings.each { |warn| @warnings << warn }
      return result unless result.is_a? Results::Success

      issues = result.issues
      file_issues =
        issues
          .map { |issue| issue.path }
          .uniq
          .map { |filepath| construct_file_issue(issues, filepath) }

      Results::Success.new(guid: guid, analyzer: analyzer, issues: file_issues)
    end

    private

    def construct_file_issue(issues, filepath)
      issues_in_file = issues.select { |issue| issue.path == filepath }
      clones = issues_in_file.length
      sum_of_lines = issues_in_file.inject(0) do |sum, issue|
        issue_obj = issue.object or raise "Required object: #{issue.inspect}"
        sum + issue_obj[:lines]
      end
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
