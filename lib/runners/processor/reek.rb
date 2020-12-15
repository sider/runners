module Runners
  class Processor::Reek < Processor
    include Ruby

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.ruby.update_fields { |f|
        f.merge!(
          target: enum?(string, array(string)),
          config: string?,
        )
      }
    end

    register_config_schema(name: :reek, schema: Schema.runner_config)

    GEM_NAME = "reek".freeze
    CONSTRAINTS = {
      GEM_NAME => [">= 4.4.0", "< 7.0.0"]
    }.freeze

    DEFAULT_TARGET = ".".freeze

    def setup
      install_gems(default_gem_specs(GEM_NAME), constraints: CONSTRAINTS) { yield }
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(changes)
      cmd = ruby_analyzer_command(*cli_args, *analysis_targets)
      stdout, stderr = capture3!(cmd.bin, *cmd.args)

      raise_warnings(stderr)

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        # NOTE: reek returns top-level JSON array
        JSON.parse(stdout, symbolize_names: true).each do |hash|
          path = relative_path(hash[:source])
          id = hash[:smell_type]
          message = "`#{hash[:context]}` #{hash[:message]}"
          links = (v4? ? [hash[:wiki_link]] : [hash[:documentation_link]]).compact

          hash[:lines].each do |line|
            result.add_issue Issue.new(
              path: path,
              location: Location.new(start_line: line),
              id: id,
              message: message,
              links: links,
            )
          end
        end
      end
    end

    private

    def analysis_targets
      targets = Array(config_linter[:target])
      targets.empty? ? [DEFAULT_TARGET] : targets
    end

    def cli_args
      %w[
        --no-color
        --failure-exit-code=0
        --line-numbers
        --format=json
      ].tap do |args|
        if v4?
          args << '--wiki-links'
        else
          args << '--documentation'
          args << '--no-progress'
        end

        config = config_linter[:config]
        if config
          args << '--config'
          args << config
        end
      end
    end

    def v4?
      return @v4 if defined? @v4

      @v4 ||= Gem::Version.create(analyzer.version).then do |v|
        v >= Gem::Version.create("4.0.0") && v < Gem::Version.create("5.0.0")
      end
    end

    def raise_warnings(stderr)
      stderr.each_line do |line|
        line.match(/Source '(.+)' cannot be processed by Reek due to a syntax error/) do |m|
          file = m.captures.first or raise "Unexpected match data: #{m.inspect}"
          file = relative_path(file).to_path
          add_warning "Detected syntax error in `#{file}`", file: file
        end
      end
    end
  end
end
