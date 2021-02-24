module Runners
  class Processor::ClangTidy < Processor
    include CPlusPlus

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.cplusplus

      let :issue, object(
        severity: string,
      )
    end

    register_config_schema(name: :clang_tidy, schema: Schema.runner_config)

    def self.config_example
      <<~'YAML'
        root_dir: project/
        apt:
          - libgdbm-dev
          - libfastjson-dev=0.99.8-2
        include-path:
          - myinclude
          - foo/include
          - /usr/include/libfastjson
      YAML
    end

    def setup
      install_apt_packages
      yield
    end

    def analyzer_bin
      "clang-tidy"
    end

    def analyze(changes)
      issues = []
      analyzed_files = []
      success_statuses = [0, 1]
      is_success = ->(status) { success_statuses.include?(status.exitstatus) }

      changes
        .changed_paths
        .select { |path| cpp_file?(path) }
        .map { |path| relative_path(working_dir / path, from: current_dir) }
        .reject { |path| path.to_s.start_with?("../") } # reject files outside the current_dir
        .each do |path|
          stdout, = capture3!(analyzer_bin, path.to_s, "--", *config_include_path, is_success: is_success)
          construct_result(stdout) { |issue| issues << issue }
          analyzed_files << path
        end

      trace_writer.message analyzed_files.empty? ? "No files to analyze." : "#{analyzed_files.size} file(s) were analyzed."

      Results::Success.new(guid: guid, analyzer: analyzer, issues: issues)
    end

    private

    def construct_result(stdout)
      # issue format
      # <path>:<line>:<column>: <severity>: <message> [<id>]
      pattern = /^(.+):(\d+):(\d+): ([^:]+): (.+) \[([^\[]+)\]$/
      stdout.scan(pattern) do |path, line, column, severity, message, id|
        raise "Unexpected match data: #{path.inspect}" unless path.is_a? String
        raise "Unexpected match data: #{path.inspect}" unless message.is_a? String

        yield Issue.new(
          path: relative_path(path),
          location: Location.new(start_line: line, start_column: column),
          id: id,
          message: message,
          object: {
            severity: severity,
          },
          schema: Schema.issue,
        )
      end
    end
  end
end
