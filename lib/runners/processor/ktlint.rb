module Runners
  class Processor::Ktlint < Processor
    include Java
    include Kotlin

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, java(
        target: target,
        ruleset: one_or_more_strings?,
        disabled_rules: one_or_more_strings?,
        experimental: boolean?,
      )
    end

    register_config_schema(name: :ktlint, schema: SCHEMA.config)

    def self.config_example
      <<~'YAML'
        root_dir: project/
        jvm_deps:
          - [my.company.com, ktlint-rules, 1.0.0]
        target:
          - "src/**/*.kt"
          - "!src/**/*Test.kt"
          - "test/"
        ruleset:
          - rules/my-ktlint-rules.jar
        disabled_rules:
          - no-wildcard-imports
          - indent
        experimental: true
      YAML
    end

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
        *((config_linter[:ruleset] || []).map { |r| ["--ruleset", r] }),
        *(comma_separated_list(config_linter[:disabled_rules]).then { |d| d ? ["--disabled_rules", d] : [] }),
        *(config_linter[:experimental] ? ["--experimental"] : []),
        *(Array(config_linter[:target]))
      )

      Results::Success.new(guid: guid, analyzer: analyzer, issues: parse_json_output(stdout))
    end

    private

    def parse_json_output(output)
      JSON.parse(output, symbolize_names: true).flat_map do |hash|
        hash.fetch(:errors).map do |error|
          Issue.new(
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
