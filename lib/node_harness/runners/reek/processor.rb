module NodeHarness
  module Runners
    module Reek
      class Processor < NodeHarness::Processor
        include NodeHarness::Ruby

        attr_reader :analyzer

        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.ruby
        end

        DEFAULT_GEMS = [
          GemInstaller::Spec.new(name: "reek", version: ["5.4.0"]),
        ].freeze

        CONSTRAINTS = {
          "reek" => [">= 4.4.0", "< 6.0"]
        }.freeze

        def self.ci_config_section_name
          'reek'
        end

        def setup
          ensure_runner_config_schema(Schema.runner_config) do
            install_gems DEFAULT_GEMS, constraints: CONSTRAINTS do |versions|
              @analyzer = NodeHarness::Analyzer.new(name: 'Reek', version: versions.fetch("reek"))
              yield
            end
          end
        rescue InstallGemsFailure => exn
          trace_writer.error exn.message
          return NodeHarness::Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
        end

        def analyze(changes)
          stdout, stderr = capture3!(
            'bundle',
            'exec',
            'reek',
            '--no-color',
            '--failure-exit-code=0',
            v4? ? '--wiki-links' : '--documentation',
            '--line-numbers',
            '--format=json',
            '.'
          )

          raise_warnings(stderr)

          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            # NOTE: reek returns top-level JSON array
            JSON.parse(stdout, symbolize_names: true).each do |hash|
              hash[:lines].each do |line|
                loc = NodeHarness::Location.new(
                  start_line: line,
                  start_column: nil,
                  end_line: nil,
                  end_column: nil
                )
                result.add_issue NodeHarness::Issues::Text.new(
                  path: relative_path(hash[:source]),
                  location: loc,
                  id: hash[:smell_type],
                  message: "[#{hash[:smell_type]}] #{hash[:context]} #{hash[:message]}",
                  links: v4? ? [hash[:wiki_link]] : [hash[:documentation_link]]
                )
              end
            end
          end
        end

        def v4?
          Gem::Version.new(analyzer.version) >= Gem::Version.new("4.0.0") && Gem::Version.new(analyzer.version) < Gem::Version.new("5.0.0")
        end

        def raise_warnings(stderr)
          stderr.each_line do |line|
            case line
            when /^*Source '(.+)' cannot be processed by Reek due to a syntax error in the source file.+$/
              file = $1
              add_warning("Detected syntax error in `#{file}`", file: relative_path(file).to_s)
            end
          end
        end
      end
    end
  end
end
