module Runners
  class Processor::Javasee < Processor
    include Java

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.base.update_fields { |hash|
        hash.merge!({
          dir: enum?(string, array(string)),
          config: string?,
        })
      }

      let :rule, object(
        id: string,
        message: string,
        justifications: array?(string),
      )
    end

    register_config_schema(name: :javasee, schema: Schema.runner_config)

    DEFAULT_CONFIG_FILE = "javasee.yml".freeze

    def extract_version_option
      "version"
    end

    def setup
      if !config_linter[:config] && !File.exist?(DEFAULT_CONFIG_FILE)
        return missing_config_file_result(DEFAULT_CONFIG_FILE)
      end

      yield
    end

    def analyze(changes)
      delete_unchanged_files changes, only: ["*.java"]

      stdout, _stderr, status = shell.capture3(
        analyzer_bin,
        "check",
        "-format", "json",
        *(config_linter[:config]&.then { |config| ["-config", config] }),
        *Array(config_linter[:dir]),
      )

      if [0, 2].include?(status.exitstatus)
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          construct_result(stdout) { |issue| result.add_issue(issue) }
        end
      else
        Results::Failure.new(guid: guid, analyzer: analyzer)
      end
    end

    private

    def construct_result(stdout)
      json = JSON.parse(stdout, symbolize_names: true)

      json.fetch(:issues).each do |hash|
        path = relative_path(hash[:script])
        loc = Location.new(
          start_line: hash[:location][:start][0],
          start_column: hash[:location][:start][1],
          end_line: hash[:location][:end][0],
          end_column: hash[:location][:end][1],
        )

        yield Issue.new(
          path: path,
          location: loc,
          id: hash[:rule][:id],
          message: hash[:rule][:message],
          object: hash[:rule],
          schema: Schema.rule
        )
      end
    end
  end
end
