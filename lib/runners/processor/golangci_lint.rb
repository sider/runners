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

    # @see https://github.com/golangci/golangci-lint/blob/v1.25.1/pkg/exitcodes/exitcodes.go
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
      if (status.exitstatus == 0 || status.exitstatus == 1) && !stdout.empty? && stderr.empty?
        return Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          parse_result(stdout) { |v| result.add_issue(v) }
        end
      end

      if status.exitstatus == 3
        message = "Analysis failed. See the log for details."
        return Results::Failure.new(guid: guid, analyzer: analyzer, message: message)
      end

      if status.exitstatus == 5
        return Results::Success.new(guid: guid, analyzer: analyzer)
      end

      raise "Analysis errored with the exit status #{status.exitstatus.inspect}."
    end

    def analyzer_options
      [].tap do |opts|
        analysis_targets.each { |target| opts << target }

        # NOTE: Always override the value in `.golangci.yml`
        opts << "--out-format=json"
        opts << "--print-issued-lines"
        opts << "--print-linter-name"
        opts << "--issues-exit-code=0"
        opts << "--color=never"
        opts << "--concurrency=2"

        # NOTE: The value should be less than the top-level timeout value.
        #
        # @see https://github.com/sider/runners/blob/1231de0ca047c7a23449ab1a7bb0751f39f16643/images/Dockerfile.end.erb#L11
        opts << "--timeout=15m"

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

      # @see https://golangci-lint.run/usage/configuration/#config-file
      default_config_file_is_found = %w[.golangci.yml .golangci.toml .golangci.json].find { |f| (current_dir / f).exist? }
      return if default_config_file_is_found

      return if config_linter[:'disable-all'] == true

      Pathname(Dir.home).join("sider_golangci.yml").to_path
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
    def parse_result(output)
      json = JSON.parse(output, symbolize_names: true)

      (json[:Issues] || []).each do |issue|
        linter = issue[:FromLinter]
        message = issue[:Text]

        # Extract ID
        id = message.match(/\A([^:]+): .+/) { |m| m.captures.first }
        id = id ? "#{linter}:#{id}" : linter

        yield Issue.new(
          path: relative_path(issue.dig(:Pos, :Filename)),
          location: Location.new(start_line: issue.dig(:Pos, :Line)),
          id: id,
          message: message,
        )
      end
    end
  end
end
