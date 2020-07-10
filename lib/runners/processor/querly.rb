module Runners
  class Processor::Querly < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.ruby.update_fields { |fields|
        fields.merge!({
          config: string?,
        })
      }

      let :rule, object(
        id: string,
        messages: array?(string),
        justifications: array?(string),
        examples: array?(object(before: string?, after: string?)),
      )
    end

    register_config_schema(name: :querly, schema: Schema.runner_config)

    OPTIONAL_GEMS = [
      GemInstaller::Spec.new(name: "slim", version: []),
      GemInstaller::Spec.new(name: "haml", version: []),
    ].freeze

    CONSTRAINTS = {
      "querly" => [">= 0.5.0", "< 2.0.0"]
    }.freeze

    CONFIG_FILE = "querly.yml".freeze
    CONFIG_FILES_GLOB = "querly.{yml,yaml}".freeze

    def analyzer_version
      @analyzer_version ||= extract_version! ruby_analyzer_bin, "version"
    end

    def setup
      install_gems default_gem_specs, optionals: OPTIONAL_GEMS, constraints: CONSTRAINTS do
        yield
      end
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(changes)
      if !config_file && !default_config_file
        return missing_config_file_result
      end

      test_config_file

      stdout, _ = capture3!(
        *ruby_analyzer_bin,
        "check",
        "--format=json",
        *(config_file ? ["--config", config_file] : []),
        ".",
      )

      json = JSON.parse(stdout, symbolize_names: true)

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        Array(json[:issues]).each do |hash|
          start_line, start_column = hash[:location][:start]
          end_line, end_column = hash[:location][:end]
          rule = hash[:rule]
          message, _ = rule[:messages]

          result.add_issue Issue.new(
            path: relative_path(hash[:script]),
            location: Location.new(
              start_line: start_line,
              start_column: start_column,
              end_line: end_line,
              end_column: end_column,
            ),
            id: rule[:id],
            message: message || "No message",
            object: rule,
            schema: Schema.rule
          )
        end
      end
    end

    private

    def config_file
      config_linter[:config]
    end

    def default_config_file
      return @default_config_file if defined? @default_config_file

      config_files = Dir.glob(CONFIG_FILES_GLOB)

      if config_files.size > 1
        file_list = config_files.map { |file| "`#{file}`" }.join(', ')
        add_warning <<~MSG, file: CONFIG_FILE
          There are duplicate configuration files (#{file_list}). Remove the files except the first one.
        MSG
      end

      @default_config_file ||= config_files.first
    end

    def missing_config_file_result
      add_warning <<~MSG, file: CONFIG_FILE
        Sider could not find the required configuration file `#{CONFIG_FILE}`.
        Please create the file according to the following documents:
        - #{analyzer_github}
        - #{analyzer_doc}
      MSG

      Results::Success.new(guid: guid, analyzer: analyzer)
    end

    def test_config_file
      stdout, _stderr, _status = capture3(
        *ruby_analyzer_bin,
        "test",
        *(config_file ? ["--config", config_file] : []),
      )

      stdout.scan(/^  (\S+:\t.+)$/) do |message, _|
        add_warning message, file: config_file || default_config_file
      end
    end
  end
end
