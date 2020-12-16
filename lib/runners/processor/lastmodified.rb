module Runners
  class Processor::LastModified < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base
      let :issue, object(
          last_modified_datetime: string
      )
    end

    register_config_schema(name: :last_modified_date, schema: Schema.runner_config)

    def preserve_dot_git_dir?
      true
    end

    def analyzer_bin
      "git"
    end

    def analyzer_version
      stdout, _, _ = capture3!(analyzer_bin, "--version")
      stdout.gsub('git version', '')
    end

    def analyze(changes)
      issues = []
      changes.changed_paths.map do |change|
        stdout, _, _ = capture3!(analyzer_bin, *analyzer_options, change.to_s)
        issues.append(
            Issue.new(
                path: change,
                location: nil,
                id: "last-modified",
                message: "(no_message)",
                links: [],
                object: {
                    last_modified_datetime: stdout.chomp,
                },
                schema: Schema.issue
            )
        )
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        issues.each { |issue| result.add_issue(issue) }
      end
    end

    private

    def analyzer_options
      ["log", '-1', "--pretty='%ai'"]
    end
  end
end


