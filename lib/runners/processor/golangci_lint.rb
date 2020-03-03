module Runners
  class Processor::GolangCiLint < Processor
    include Go

    Schema =
      StrongJSON.new do
        let :runner_config,
            Schema::BaseConfig.base.update_fields { |fields|
              fields.merge!(
                {
                  target: enum?(string, array(string)),
                  config: string?,
                  disable: enum?(string, array(string)),
                  'disable-all': boolean?,
                  enable: enum?(string, array(string)),
                  fast: boolean?,
                  'no-config': boolean?,
                  presets: enum?(string, array(string)),
                  'skip-dirs': enum?(string, array(string)),
                  'skip-dirs-use-default': boolean?,
                  'skip-files': enum?(string, array(string)),
                  tests: boolean?,
                  'uniq-by-line': boolean?
                }
              )
            }

        let :issue, object(severity: string?)
      end

    register_config_schema(name: :golangci_lint, schema: Schema.runner_config)

    DEFAULT_TARGET = "./...".freeze

    def analyzer_bin
      "golangci-lint"
    end

    def analyze(_changes)
      run_analyzer
    end

    private

    # @see https://github.com/golangci/golangci-lint/blob/v1.23.1/pkg/exitcodes/exitcodes.go
    #     Success              = 0
    #     IssuesFound          = 1
    #     WarningInTest        = 2
    #     Failure              = 3
    #     Timeout              = 4
    #     NoGoFiles            = 5
    #     NoConfigFileDetected = 6
    #     ErrorWasLogged       = 7

    def run_analyzer
      stdout, stderr, status = capture3(analyzer_bin, "run", *analyzer_options)
      if (status.exitstatus == 0 || status.exitstatus == 1) && stdout && stderr.empty?
        return(
          Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
            parse_result(stdout).each { |v| result.add_issue(v) }
          end
        )
      end

      if status.exitstatus == 3
        return Results::Failure.new(guid: guid, analyzer: analyzer, message: handle_respective_message(stderr))
      end

      if status.exitstatus == 5
        return Results::Failure.new(guid: guid, analyzer: analyzer, message: "No go files to analyze")
      end

      Results::Failure.new(guid: guid, analyzer: analyzer, message: "Running error")
    end

    def handle_respective_message(stderr)
      case stderr
      when /must enable at least one/
        "Must enable at least one linter"
      when /can't be disabled and enabled at one moment/
        "Can't be disabled and enabled at one moment"
      when /can't combine options --disable-all and --disable/
        "Can't combine options --disable-all and --disable"
      when /only next presets exist/
        "Only next presets exist: (bugs|complexity|format|performance|style|unused)"
      when /no such linter/
        "No such linter"
      when /can't combine option --config and --no-config/
        "Can't combine option --config and --no-config"
      else
        msg = stderr.match(/level=error msg=.+\[(.+)\]/)
        msg && msg[1] ? msg[1] : "Running Error"
      end
    end

    def analyzer_options
      [].tap do |opts|
        analysis_targets.each { |target| opts << target }
        opts << "--out-format=json"
        opts << "--issues-exit-code=0"
        opts << "--tests=#{config_linter[:tests]}" unless config_linter[:tests].nil?
        opts << "--config=#{path_to_config}" if path_to_config
        Array(config_linter[:disable]).each { |disable| opts << "--disable=#{disable}" }
        Array(config_linter[:enable]).each { |enable| opts << "--enable=#{enable}" }
        Array(config_linter[:presets]).each { |preset| opts << "--presets=#{preset}" }
        Array(config_linter[:'skip-dirs']).each { |dir| opts << "--skip-dirs=#{dir}" }
        Array(config_linter[:'skip-files']).each { |file| opts << "--skip-files=#{file}" }
        opts << "--uniq-by-line=#{config_linter[:'uniq-by-line']}" unless config_linter[:'uniq-by-line'].nil?
        opts << "--no-config=#{config_linter[:'no-config']}" unless config_linter[:'no-config'].nil?
        unless config_linter[:'skip-dirs-use-default'].nil?
          opts << "--skip-dirs-use-default=#{config_linter[:'skip-dirs-use-default']}"
        end
        opts << "--disable-all=#{config_linter[:'disable-all']}" unless config_linter[:'disable-all'].nil?
      end
    end

    def path_to_config
      return config_linter[:config] if config_linter[:config]

      # @see https://github.com/golangci/golangci-lint#config-file
      candidates = %w[.golangci.yml .golangci.toml .golangci.json].map { |filename| current_dir / filename }

      return if candidates.find(&:exist?)
      "sider_golangci.yml".tap { |file| FileUtils.cp(Pathname(Dir.home) / file, current_dir) } unless config_linter[:'disable-all'] == true
    end

    def analysis_targets
      Array(config_linter[:target] || DEFAULT_TARGET)
    end

    # Output format:
    #
    #      ["{"Issues":[{"FromLinter":"govet","Text":"printf: Printf call has arguments but no formatting directives",
    #      "SourceLines":["\tfmt.Printf(\\\"text\\\", awesome_text)\"],\"Replacement\":null,
    #      \"Pos\":{\"Filename\":\"test/smokes/golangci_lint/success/main.go\",\"Offset\":85,\"Line\":7,\"Column\":12}}],
    #      \"Report\":{\"Linters\":[{\"Name\":\"govet\",\"Enabled\":true,\"EnabledByDefault\":true},
    #      {\"Name\":\"bodyclose\"}...
    #
    # Example:
    #
    #     {:FromLinter=>"govet", :Text=>"printf: Printf call has arguments but no formatting directives",
    #     :SourceLines=>["\tfmt.Printf(\"text\", awesome_text)"], :Replacement=>nil,
    #     :Pos=>{:Filename=>"test/smokes/golangci_lint/success/main.go", :Offset=>85, :Line=>7, :Column=>12}}
    #
    # @param stdout [String]
    def parse_result(stdout)
      json = JSON.parse(stdout, symbolize_names: true)
      return [] unless json[:Issues]

      json[:Issues].map do |file|
        path = relative_path(file[:Pos][:Filename])

        line = file[:Pos][:Line]
        id = generate_issue_id(file[:FromLinter], file[:Text])

        Issue.new(path: path, location: Location.new(start_line: line), id: id, message: file[:Text], links: [])
      end
    end

    def generate_issue_id(linter_name, message)
      case linter_name
      when "govet", "staticcheck", "gosimple", "gocritic", "gosec", "stylecheck"
        message.match(/\A(?<rule>[^:]+): .+/) { |m| "#{linter_name}:#{m.named_captures["rule"]}" } || linter_name
      else
        linter_name
      end
    end
  end
end
