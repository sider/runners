module NodeHarness
  module Runners
    module Brakeman
      class Processor < NodeHarness::Processor
        include NodeHarness::Ruby

        attr_reader :analyzer

        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.ruby
        end

        DEFAULT_GEMS = [
          GemInstaller::Spec.new(name: "brakeman", version: ["4.3.1"]),
        ].freeze

        CONSTRAINTS = {
          "brakeman" => [">= 4.0.0", "< 4.4.0"]
        }.freeze

        def self.ci_config_section_name
          # Section name in sideci.yml, Generally it is the name of analyzer tool.
          "brakeman"
        end

        def setup
          ensure_runner_config_schema(Schema.runner_config) do
            install_gems DEFAULT_GEMS, constraints: CONSTRAINTS do |versions|
              @analyzer = NodeHarness::Analyzer.new(name: 'brakeman', version: versions.fetch("brakeman"))
              yield
            end
          end
        rescue InstallGemsFailure => exn
          trace_writer.error exn.message
          return NodeHarness::Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
        end

        def analyze(changes)
          # run analysis and return result
          stdout, stderr, status = capture3('bundle', 'exec', 'brakeman', '--format=json', '--no-exit-on-warn', '--no-exit-on-error')
          return NodeHarness::Results::Failure.new(guid: guid, message: stderr, analyzer: analyzer!) unless status.success?
          construct_result(stdout)
        end

        def construct_result(stdout)
          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            json = JSON.parse(stdout, symbolize_names: true)
            json[:warnings].each do |warning|
              path = relative_path(warning[:file])
              # http://brakemanscanner.org/docs/warning_types/basic_authentication などはlineを持たない
              line = warning[:line].nil? ? 0 : warning[:line].to_i
              loc = NodeHarness::Location.new(start_line: line,
                                              start_column: nil,
                                              end_line: nil,
                                              end_column: nil)

              result.add_issue NodeHarness::Issues::Text.new(
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
  end
end
