module Runners
  class Processor::GolangCiLint < Processor
    include Go

    Schema = _ =
      StrongJSON.new do
        # @type self: SchemaClass

        let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
          fields.merge!({
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
          })
        }

        # @see https://github.com/golangci/golangci-lint/blob/v1.36.0/pkg/result/issue.go#L27
        let :issue, object(
          severity: string,
          replacement: object?(
            NeedOnlyDelete: boolean,
            NewLines: array?(string),
            Inline: object?(
              StartCol: integer,
              Length: integer,
              NewString: string,
            ),
          ),
        )
      end

    register_config_schema(name: :golangci_lint, schema: Schema.runner_config)

    DEFAULT_TARGET = "./...".freeze
    DEFAULT_CONFIG_FILE = (Pathname(Dir.home) / "sider_golangci.yml").to_path.freeze

    # @see https://golangci-lint.run/usage/configuration/#config-file
    SUPPORTED_CONFIG_FILES = %w[
      .golangci.yml
      .golangci.yaml
      .golangci.toml
      .golangci.json
    ].freeze

    def analyzer_bin
      "golangci-lint"
    end

    def analyze(_changes)
      # @see https://github.com/golangci/golangci-lint/blob/v1.36.0/pkg/exitcodes/exitcodes.go#L4-L11
      ex_success = 0
      ex_issues_found = 1
      ex_failure = 3
      ex_no_go_files = 5

      stdout, stderr, status = capture3(analyzer_bin, "run", *analyzer_options)

      if [ex_success, ex_issues_found].include?(status.exitstatus) && !stdout.empty? && stderr.empty?
        return Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          parse_result(stdout) { |v| result.add_issue(v) }
        end
      end

      if status.exitstatus == ex_failure
        return Results::Failure.new(guid: guid, analyzer: analyzer)
      end

      if status.exitstatus == ex_no_go_files
        return Results::Success.new(guid: guid, analyzer: analyzer)
      end

      raise "Analysis errored with the exit status #{status.exitstatus.inspect}."
    end

    private

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

        # NOTE: Set `--timeout` to prevent a user-defined timeout value via `.golangci.yml`.
        #       This value should be enough greater than the top-level timeout value `ENV['RUNNERS_TIMEOUT']`.
        opts << "--timeout=10h"

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
      return if config_linter[:'disable-all'] == true
      return if SUPPORTED_CONFIG_FILES.any? { |file| File.exist?(file) }

      DEFAULT_CONFIG_FILE
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
          location: Location.new(start_line: issue.dig(:Pos, :Line), start_column: issue.dig(:Pos, :Column)),
          id: id,
          message: message,
          object: {
            severity: issue[:Severity],
            replacement: issue[:Replacement],
          },
          schema: Schema.issue,
        )
      end
    end
  end
end
