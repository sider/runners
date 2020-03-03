module Runners
  class Processor::Reek < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.ruby
    end

    register_config_schema(name: :reek, schema: Schema.runner_config)

    CONSTRAINTS = {
      "reek" => [">= 4.4.0", "< 6.0"]
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
      stdout, stderr = capture3!(
        *ruby_analyzer_bin,
        '--no-color',
        '--failure-exit-code=0',
        v4? ? '--wiki-links' : '--documentation',
        '--line-numbers',
        '--format=json',
        '.'
      )

      raise_warnings(stderr)

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        # NOTE: reek returns top-level JSON array
        JSON.parse(stdout, symbolize_names: true).each do |hash|
          hash[:lines].each do |line|
            result.add_issue Issue.new(
              path: relative_path(hash[:source]),
              location: Location.new(start_line: line),
              id: hash[:smell_type],
              message: "`#{hash[:context]}` #{hash[:message]}",
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
