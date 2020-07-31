module Runners
  class Processor::Ktlint < Processor
    include Java
    include Kotlin

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.java.update_fields { |fields|
        fields.merge!({
          target: enum?(string, array(string)),
          ruleset: enum?(string, array(string)),
          disabled_rules: enum?(string, array(string)),
          experimental: boolean?,
        })
      }
    end

    register_config_schema(name: :ktlint, schema: Schema.runner_config)

    def setup
      begin
        install_jvm_deps
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message)
      end

      yield
    end

    def analyze(changes)
      delete_unchanged_files changes, only: kotlin_file_extensions

      stdout, = capture3(
        analyzer_bin,
        "--reporter", "json",
        *(Array(config_linter[:ruleset]).map { |r| ["--ruleset", r] }),
        *(comma_separated_list(config_linter[:disabled_rules])&.then { |d| ["--disabled_rules", d] }),
        *(config_linter[:experimental] ? ["--experimental"] : nil),
        *(Array(config_linter[:target]))
      )

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        parse_json_output(stdout) do |issue|
          result.add_issue issue
        end
      end
    end

    private

    def parse_json_output(output)
      JSON.parse(output, symbolize_names: true).each do |hash|
        hash.fetch(:errors).each do |error|
          yield Issue.new(
            path: relative_path(hash.fetch(:file)),
            location: Location.new(start_line: error[:line], start_column: error[:column]),
            id: error[:rule],
            message: error[:message],
          )
        end
      end
    end
  end
end
