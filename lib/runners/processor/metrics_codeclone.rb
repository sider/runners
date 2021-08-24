module Runners
  class Processor::MetricsCodeClone < Processor
    extend Forwardable

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :issue, object(
        clones: integer,
        total_clone_lines: integer,
      )
    end

    def_delegators :@pmd_cpd,
      :add_warning,
      :warnings,
      :config_linter,
      :analyzer_bin,
      :analyzer_version,
      :check_root_dir_exist,
      :show_runtime_versions,
      :setup,
      :use_git_metadata_dir?

    def initialize(...)
      super(...)
      @pmd_cpd = PmdCpd.new(...).tap { |obj| obj.force_option_skip_lexical_errors = true }
    end

    def analyze(changes)
      result = @pmd_cpd.analyze(changes)
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
      sum_of_lines = issues_in_file.sum do |issue|
        issue_obj = issue.object or raise "Required object: #{issue.inspect}"
        issue_obj.fetch(:lines)
      end
      msg = "The number of code clones is #{clones} with total #{sum_of_lines} lines."

      Issue.new(
        path: filepath,
        location: nil,
        id: "metrics_codeclone",
        message: msg,
        object: {
          clones: clones,
          total_clone_lines: sum_of_lines,
        },
        schema: SCHEMA.issue,
      )
    end
  end
end
