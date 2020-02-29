module Runners
  class Processor::Querly < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.ruby

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

    def self.ci_config_section_name
      'querly'
    end

    def analyzer_name
      'querly'
    end

    def analyzer_version
      @analyzer_version ||= extract_version! ruby_analyzer_bin, "version"
    end

    def setup
      ret = install_gems default_gem_specs, optionals: OPTIONAL_GEMS, constraints: CONSTRAINTS do
        analyzer
        yield
      end

      # NOTE: Exceptionally MissingFileFailure is treated as successful
      if ret.instance_of? Results::MissingFilesFailure
        add_warning(<<~MESSAGE)
          Sider cannot find the required configuration file `querly.yml`.
          Please set up Querly by following the instructions, or you can disable it in the repository settings.

          - https://github.com/soutaro/querly
          - https://help.sider.review/tools/ruby/querly
        MESSAGE
        Results::Success.new(guid: guid, analyzer: analyzer)
      else
        ret
      end
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(changes)
      capture3!(*ruby_analyzer_bin, "version")

      ensure_files relative_path("querly.yml"), relative_path("querly.yaml") do |config_file|
        test_config_file(config_file)

        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          stdout, _ = capture3!(*ruby_analyzer_bin, "check", "--format=json", ".")

          json = JSON.parse(stdout, symbolize_names: true)
          Array(json[:issues]).each do |hash|
            path = relative_path(hash[:script])
            loc = Location.new(start_line: hash[:location][:start][0],
                                            start_column: hash[:location][:start][1],
                                            end_line: hash[:location][:end][0],
                                            end_column: hash[:location][:end][1])
            msgs = hash[:rule][:messages]
            result.add_issue Issue.new(
              path: path,
              location: loc,
              id: hash[:rule][:id],
              message: (msgs && msgs[0]) || "No message",
              object: hash[:rule],
              schema: Schema.rule
            )
          end
        end
      end
    end

    def test_config_file(config_file)
      stdout, _stderr, _status = capture3(*ruby_analyzer_bin, 'test')

      warnings = stdout.each_line.map do |line|
        match = line.match(/\A  (\S+:\t.+)\Z/)
        next unless match
        match[1]
      end.compact

      warnings.each do |warn|
        add_warning(warn, file: config_file.to_s)
      end
    end
  end
end
