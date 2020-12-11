module Runners
  class Processor::Brakeman < Processor
    include Ruby

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.ruby

      let :issue, object(
        severity: string,
      )
    end

    register_config_schema(name: :brakeman, schema: Schema.runner_config)

    GEM_NAME = "brakeman".freeze
    CONSTRAINTS = {
      GEM_NAME => [">= 4.0.0", "< 5.0.0"]
    }.freeze

    def setup
      install_gems(default_gem_specs(GEM_NAME), constraints: CONSTRAINTS) { yield }
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(changes)
      cmd = ruby_analyzer_command(
        '--format=json',
        '--output', report_file,
        '--no-exit-on-warn',
        '--no-exit-on-error',
        '--no-progress',
        '--quiet',
      )
      _, stderr, status = capture3(cmd.bin, *cmd.args)

      unless status.success?
        if stderr.include?("Please supply the path to a Rails application")
          add_warning <<~MSG, file: config.path_name
            #{analyzer_name} is for Rails only. Your repository may not have a Rails application.
            If your Rails is not located in the root directory, configure your `#{config.path_name}` as follows:

            ```yaml
            linter:
              #{analyzer_id}:
                root_dir: "path/to/your/rails/root"
            ```
          MSG
          return Results::Success.new(guid: guid, analyzer: analyzer)
        else
          raise stderr
        end
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        json = read_report_json

        json[:warnings].each do |warning|
          line = warning[:line]
          result.add_issue Issue.new(
            path: relative_path(warning[:file]),
            location: line ? Location.new(start_line: line) : nil,
            id: "#{warning[:warning_type]}-#{warning[:warning_code]}",
            message: warning[:message],
            links: [warning[:link]],
            object: {
              severity: warning[:confidence],
            },
            schema: Schema.issue,
          )
        end

        json[:errors].each do |error|
          add_warning error[:error]
        end
      end
    end
  end
end
