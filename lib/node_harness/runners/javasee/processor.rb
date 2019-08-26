module NodeHarness
  module Runners
    module Javasee
      class Processor < NodeHarness::Processor
        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.base.update_fields { |hash|
            hash[:dir] = enum?(string, array(string), detector: -> (value) {
              case value
              when String
                string
              when Array
                array(string)
              end
            })
            hash[:config] = string?
          }

          let :rule, object(
            id: string,
            message: string,
            justifications: array?(string),
          )
        end

        def self.ci_config_section_name
          'javasee'
        end

        def javasee
          ENV["JAVASEE_EXECUTABLE"] || "javasee"
        end

        def javasee_check(dirs:, config_path:)
          args = []
          args.push("-config", config_path.to_s)

          shell.capture3(javasee,
                         "check",
                         "-config", config_path.to_s,
                         "-format", "json",
                         *dirs.map(&:to_s))
        end

        def analyzer_version
          @analyzer_version ||=
            begin
              stdout, _ = shell.capture3!(javasee, "version")
              match = stdout.match(/(\d+\.\d+\.\d+\.)/)
              if match
                match.captures.first
              else
                raise "Not found version in #{stdout.inspect}"
              end
            end
        end

        def analyzer
          @analyzer ||= NodeHarness::Analyzer.new(name: 'javasee', version: analyzer_version)
        end

        def analyze(changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            analyzer_version

            delete_unchanged_files changes, only: [".java"]

            check_runner_config(config) do |dirs, config_path|
              stdout, stderr, status = javasee_check dirs: dirs, config_path: config_path

              if status.success? || status.exitstatus == 2
                NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
                  construct_result(result, stdout, stderr)
                end
              else
                NodeHarness::Results::Failure.new(
                  guid: guid,
                  analyzer: analyzer,
                  message: <<~MESSSAGE
                    stdout:
                    #{stdout}

                    stderr:
                    #{stderr}
                  MESSSAGE
                )
              end
            end
          end
        end

        def construct_result(result, stdout, stderr)
          json = JSON.parse(stdout, symbolize_names: true)

          json[:issues].each do |hash|
            path = relative_path(hash[:script])
            loc = NodeHarness::Location.new(start_line: hash[:location][:start][0],
                                            start_column: hash[:location][:start][1],
                                            end_line: hash[:location][:end][0],
                                            end_column: hash[:location][:end][1])

            result.add_issue NodeHarness::Issues::Structured.new(
              path: path,
              location: loc,
              id: hash[:rule][:id],
              object: hash[:rule],
              schema: Schema.rule
            )
          end
        end

        def check_runner_config(config)
          dirs = Array(config[:dir] || ".").map { |d| Pathname(d) }
          trace_writer.message("Checking directory: #{dirs}")

          config_path = Pathname(config[:config] || "javasee.yml")
          trace_writer.message "Using configuration: #{config_path}"

          yield dirs, config_path
        end
      end
    end
  end
end
