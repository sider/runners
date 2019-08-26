module NodeHarness
  module Runners
    module ScssLint
      class Processor < NodeHarness::Processor
        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, object(
            root_dir: string?,
            config: string?,
            # DO NOT ADD ANY OPTIONS in `options` option.
            options: optional(object(
                                config: string?
                              ))
          )
        end

        # https://github.com/brigade/scss-lint#exit-status-codes
        EXIT_CODE_FILES_NOT_EXIST = 80

        def analyzer_version
          @analyzer_version ||=
            begin
              stdout, _ = capture3!('scss-lint', '--version')
              match = stdout.match(/scss-lint ([0-9.]+)/)
              if match
                match.captures.first
              else
                raise "Not found version in #{stdout.inspect}"
              end
            end
        end

        def analyzer
          NodeHarness::Analyzer.new(name: "SCSS-Lint", version: analyzer_version)
        end

        def self.ci_config_section_name
          'scss_lint'
        end

        def setup
          yield
        end

        def analyze(changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            check_runner_config(config) do |options|
              run_analyzer(options)
            end
          end
        end

        def check_runner_config(config)
          scss_lint_config = scss_lint_config(config)
          yield(scss_lint_config ? [scss_lint_config] : [])
        end

        def scss_lint_config(config)
          config = config[:config] || config.dig(:options, :config)
          "--config=#{config}" if config
        end

        def parse_result(stdout)
          JSON.parse(stdout).flat_map do |file, issues|
            issues.map do |issue|
              line = issue['line']
              message = issue['reason']
              id = issue['linter']

              loc = NodeHarness::Location.new(
                start_line: line,
                start_column: nil,
                end_line: nil,
                end_column: nil
              )
              NodeHarness::Issues::Text.new(
                path: relative_path(file),
                location: loc,
                id: id,
                message: message,
                links: []
              )
            end
          end
        end

        def run_analyzer(options)
          stdout, stderr, status = capture3('scss-lint', '--format=JSON', *options)
          # https://github.com/brigade/scss-lint#exit-status-codes
          case status.exitstatus
          when 0..2
            NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
              parse_result(stdout).each { |v| result.add_issue(v) }
            end
          when EXIT_CODE_FILES_NOT_EXIST
            # NOTE: If there are no analysis target files, returns `Success` with a warning.
            add_warning(stdout.chomp)
            NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!)
          else
            NodeHarness::Results::Failure.new(guid: guid, message: <<~MESSAGE, analyzer: analyzer!)
              stdout:
              #{stdout}

              stderr:
              #{stderr}
            MESSAGE
          end
        end
      end
    end
  end
end
