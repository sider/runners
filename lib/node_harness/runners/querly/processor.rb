module NodeHarness
  module Runners
    module Querly
      class Processor < NodeHarness::Processor
        include NodeHarness::Ruby

        attr_reader :analyzer

        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.ruby

          let :rule, object(
            id: string,
            messages: array?(string),
            justifications: array?(string),
            examples: array?(object(before: string?, after: string?)),
          )
        end

        DEFAULT_GEMS = [
          GemInstaller::Spec.new(name: "querly", version: ["1.0.0"]),
        ].freeze

        OPTIONAL_GEMS = [
          GemInstaller::Spec.new(name: "slim", version: []),
          GemInstaller::Spec.new(name: "haml", version: []),
        ].freeze

        CONSTRAINTS = {
          "querly" => [">= 0.5.0", "< 2.0.0"]
        }.freeze

        def self.ci_config_section_name
          'querly'
        end

        def setup
          ret = ensure_runner_config_schema(Schema.runner_config) do
            install_gems DEFAULT_GEMS, optionals: OPTIONAL_GEMS, constraints: CONSTRAINTS do |versions|
              @analyzer = NodeHarness::Analyzer.new(name: 'querly', version: versions.fetch("querly"))
              yield
            end
          end

          # NOTE: Exceptionally MissingFileFailure is treated as successful
          if ret.instance_of? NodeHarness::Results::MissingFilesFailure
            add_warning(<<~MESSAGE)
              Sider cannot find the required configuration file `querly.yml`.
              Please set up Querly by following the instructions, or you can disable it in the repository settings.

              - https://github.com/soutaro/querly
              - https://help.sider.review/tools/ruby/querly
            MESSAGE
            NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!)
          else
            ret
          end
        rescue InstallGemsFailure => exn
          trace_writer.error exn.message
          return NodeHarness::Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
        end

        def analyze(changes)
          capture3!("bundle", "exec", "querly", "version")

          ensure_files relative_path("querly.yml"), relative_path("querly.yaml") do |config_file|
            test_config_file(config_file)

            NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
              stdout, _ = capture3!("bundle", "exec", "querly", "check", "--format=json", ".")

              json = JSON.parse(stdout, symbolize_names: true)
              Array(json[:issues]).each do |hash|
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
          end
        end

        def test_config_file(config_file)
          stdout, _stderr, _status = capture3('bundle', 'exec', 'querly', 'test')

          warnings = stdout.lines.each_with_object([]) do |line, warns|
            match = line.match(/\A  (\S+:\t.+)\Z/)
            if match
              warns << match[1]
            end
          end

          warnings.each do |warn|
            add_warning(warn, file: config_file.to_s)
          end
        end
      end
    end
  end
end
