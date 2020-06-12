module Runners
  class Processor::Brakeman < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.ruby

      let :issue, object(
        severity: string,
      )
    end

    register_config_schema(name: :brakeman, schema: Schema.runner_config)

    CONSTRAINTS = {
      "brakeman" => [">= 4.0.0", "< 5.0.0"]
    }.freeze

    def setup
      install_gems default_gem_specs, constraints: CONSTRAINTS do
        yield
      end
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(changes)
      # run analysis and return result
      _, stderr, status = capture3(
        *ruby_analyzer_bin,
        '--format=json',
        '--output', report_file,
        '--no-exit-on-warn',
        '--no-exit-on-error',
        '--no-progress',
        '--quiet',
      )
      return Results::Failure.new(guid: guid, message: stderr, analyzer: analyzer) unless status.success?
      construct_result
    end

    def construct_result
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
