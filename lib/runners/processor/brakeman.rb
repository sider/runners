module Runners
  class Processor::Brakeman < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.ruby
    end

    register_config_schema(name: :brakeman, schema: Schema.runner_config)

    CONSTRAINTS = {
      "brakeman" => [">= 4.0.0", "< 4.4.0"]
    }.freeze

    def setup
      install_gems default_gem_specs, constraints: CONSTRAINTS do
        analyzer
        yield
      end
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(changes)
      # run analysis and return result
      stdout, stderr, status = capture3(
        *ruby_analyzer_bin,
        '--format=json',
        '--no-exit-on-warn',
        '--no-exit-on-error',
        '--no-progress',
        '--quiet',
      )
      return Results::Failure.new(guid: guid, message: stderr, analyzer: analyzer) unless status.success?
      construct_result(stdout)
    end

    def construct_result(stdout)
      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        json = JSON.parse(stdout, symbolize_names: true)
        json[:warnings].each do |warning|
          path = relative_path(warning[:file])
          # http://brakemanscanner.org/docs/warning_types/basic_authentication などはlineを持たない
          line = warning[:line].nil? ? 0 : warning[:line].to_i
          loc = Location.new(start_line: line,
                                          start_column: nil,
                                          end_line: nil,
                                          end_column: nil)

          result.add_issue Issue.new(
            path: path,
            location: loc,
            id: "#{warning[:warning_type]}-#{warning[:warning_code]}",
            message: warning[:message],
            links: [warning[:link]]
          )
        end

        json[:errors].each do |error|
          add_warning error[:error]
        end
      end
    end
  end
end
