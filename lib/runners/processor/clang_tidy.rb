module Runners
  class Processor::ClangTidy < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
          apt: enum?(string, array(string))
        })
      }

      let :issue, object(
        severity: string,
      )
    end

    register_config_schema(name: :clang_tidy, schema: Schema.runner_config)

    VALID_EXTENSIONS = [".c", ".cc", ".cpp", ".c++", ".cp", ".cxx"].freeze

    def analyze(changes)
      deploy_packages
      run_analyzer(changes)
    end

    private

    def deploy_packages
      if config_linter[:apt]
        # TODO select "lib*" and report others as warning
        packages = Array(config_linter[:apt])
        capture3!("sudo", "apt-get", "install", "-y", "--no-install-recommends", *packages)
      end
    end

    def analyzer_bin
      "clang-tidy"
    end

    def run_analyzer(changes)
      issues = []

      changes
        .changed_paths
        .select { |path| VALID_EXTENSIONS.include?(path.extname.downcase) }
        .map{ |path| relative_path(working_dir / path, from: current_dir) }
        .each do |path|
          stdout, stderr = capture3!(analyzer_bin, path.to_s, "--",
            is_success: ->(status) { [0, 1].include?(status.exitstatus) })
          ret = construct_result(stdout)
          issues.push(*ret)
        end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        result.add_issue(*issues)
      end
    end

    def construct_result(stdout)
      issues = []

      stdout.each_line do |line|
        # group: 1      2      3         4           5          6
        #        <path>:<line>:<column>: <severity>: <message> [<id>]
        match = line.strip.match(/^(?<path>.+):(?<line>\d+):(?<column>\d+): (?<severity>[^:]+): (?<message>.+) \[(?<id>[^\[]+)\]$/)
        if match
          start_line = Integer(match[:line])
          start_column = Integer(match[:column])
          issues << Issue.new(
            path: relative_path(match[:path]),
            location: Location.new(start_line: start_line, start_column: start_column, end_line: start_line, end_column: start_column),
            id: match[:id],
            message: match[:message],
            object: {
              severity: match[:severity],
            },
            schema: Schema.issue,
          )
        end
      end

      issues
    end
  end
end
