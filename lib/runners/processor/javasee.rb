module Runners
  class Processor::Javasee < Processor
    include Java

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |hash|
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

    register_config_schema(name: :javasee, schema: Schema.runner_config)

    def self.ci_config_section_name
      'javasee'
    end

    def analyzer_bin
      "javasee"
    end

    def javasee_check(dirs:, config_path:)
      args = ["-format", "json"]
      args.push("-config", config_path.to_s) if config_path

      shell.capture3(analyzer_bin, "check", *args, *dirs.map(&:to_s))
    end

    def analyzer_version
      @analyzer_version ||= extract_version! analyzer_bin, "version"
    end

    def analyzer_name
      'javasee'
    end

    def analyze(changes)
      analyzer_version

      delete_unchanged_files changes, only: [".java"]

      check_runner_config do |dirs, config_path|
        stdout, stderr, status = javasee_check dirs: dirs, config_path: config_path

        if status.success? || status.exitstatus == 2
          Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
            construct_result(result, stdout, stderr)
          end
        elsif stderr.match?(/Configuration file .+ does not look a file/)
          add_warning stderr
          return Results::Success.new(guid: guid, analyzer: analyzer)
        else
          Results::Failure.new(
            guid: guid,
            analyzer: analyzer,
            message: stderr,
          )
        end
      end
    end

    def construct_result(result, stdout, stderr)
      json = JSON.parse(stdout, symbolize_names: true)

      json[:issues].each do |hash|
        path = relative_path(hash[:script])
        loc = Location.new(start_line: hash[:location][:start][0],
                                        start_column: hash[:location][:start][1],
                                        end_line: hash[:location][:end][0],
                                        end_column: hash[:location][:end][1])

        result.add_issue Issue.new(
          path: path,
          location: loc,
          id: hash[:rule][:id],
          message: hash[:rule][:message],
          object: hash[:rule],
          schema: Schema.rule
        )
      end
    end

    def check_runner_config
      dirs = Array(ci_section[:dir]).map { |dir| Pathname(dir) }

      config_path = ci_section[:config]
      config_path = Pathname(config_path) if config_path

      yield dirs, config_path
    end
  end
end
