module NodeHarness
  module Runners
    module Eslint
      class Processor < NodeHarness::Processor
        include NodeHarness::Nodejs

        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.npm.update_fields { |fields|
            fields.merge!({
                            dir: enum?(string, array(string)),
                            ext: string?,
                            config: string?,
                            'ignore-path': string?,
                            'ignore-pattern': enum?(string, array(string)),
                            'no-ignore': boolean?,
                            global: string?,
                            quiet: boolean?,
                            # NOTE: DO NOT ADD ANY OPTIONS to internal `options` option because the option has been deprecated.
                            options: optional(object(
                                                npm_install: enum?(boolean, literal('development'), literal('production')),
                                                dir: enum?(string, array(string)),
                                                ext: string?,
                                                config: string?,
                                                'ignore-path': string?,
                                                'no-ignore': boolean?,
                                                'ignore-pattern': enum?(string, array(string)),
                                                global: string?,
                                                quiet: boolean?
                                              ))
                          })
          }
        end

        DEFAULT_DEPS = DefaultDependencies.new(main: Dependency.new(name: "eslint", version: "5.16.0")).freeze
        CONSTRAINTS = {
          "eslint" => Constraint.new(">= 3.19.0", "< 7.0.0")
        }.freeze

        def self.ci_config_section_name
          'eslint'
        end

        def nodejs_analyzer_command
          "eslint"
        end

        def analyzer
          @analyzer ||= NodeHarness::Analyzer.new(name: 'ESLint', version: nodejs_analyzer_version)
        end

        def setup
          ensure_runner_config_schema(Schema.runner_config) do |config|
            begin
              install_nodejs_deps(DEFAULT_DEPS, constraints: CONSTRAINTS, install_option: config[:npm_install])
            rescue UserError => exn
              return NodeHarness::Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
            end
            analyzer
            yield
          end
        end

        def analyze(changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            check_runner_config(config) do |dir, additional_options|
              run_analyzer(dir, additional_options)
            end
          end
        end

        private

        def check_runner_config(config)
          # Required option, which has the default value.
          dir = dir(config)

          # Additional options
          eslint_config = eslint_config(config)
          ext = ext(config)
          ignore_path = ignore_path(config)
          ignore_pattern = ignore_pattern(config)
          no_ignore = no_ignore(config)
          global = global(config)
          quiet = quiet(config)

          additional_options = [eslint_config, ext, ignore_path, ignore_pattern, no_ignore, global, quiet].flatten.compact
          yield dir, additional_options
        end

        def dir(config)
          dir = config[:dir] || config.dig(:options, :dir) || '.'
          Array(dir)
        end

        def eslint_config(config)
          conf = user_specified_eslint_config_path(config)
          "--config=#{conf}" if conf
        end

        def user_specified_eslint_config_path(config)
          path = config[:config] || config.dig(:options, :config)
          if path && directory_traversal_attack?(path)
            path = nil
          end
          path
        end

        def ext(config)
          ext = config[:ext] || config.dig(:options, :ext)
          "--ext=#{ext}" if ext
        end

        def ignore_path(config)
          # FIXME: This `@type` comment is unneeded ideally.
          # @type var config: any
          ignore_path = config[:'ignore-path'] || config.dig(:options, :'ignore-path')
          "--ignore-path=#{ignore_path}" if ignore_path
        end

        def ignore_pattern(config)
          # FIXME: This `@type` comment is unneeded ideally.
          # @type var config: any
          ignore_pattern = config[:'ignore-pattern'] || config.dig(:options, :'ignore-pattern')
          Array(ignore_pattern).map { |value| "--ignore-pattern=#{value}" }
        end

        def no_ignore(config)
          # FIXME: This `@type` comment is unneeded ideally.
          # @type var config: any
          no_ignore = config[:'no-ignore'] || config.dig(:options, :'no-ignore')
          "--no-ignore" if no_ignore
        end

        def global(config)
          global = config[:global] || config.dig(:options, :global)
          "--global='#{global}'" if global
        end

        def quiet(config)
          quiet = config[:quiet] || config.dig(:options, :quiet)
          "--quiet" if quiet
        end

        def severity_hander(issue)
          case issue[:severity]
          when 1
            'Warning'
          when 2
            'Error'
          else
            raise "Unknown serverity: #{issue[:severity]}"
          end
        end

        def issue_parameters(details)
          rule_id = details[:ruleId]
          rule_message = details[:message]
          message =
            if rule_id
              "#{severity_hander(details)} - #{rule_message} (#{rule_id})"
            else
              "#{severity_hander(details)} - #{rule_message}"
            end
          unless rule_id
            trace_writer.message("No id found! - #{rule_message}")
            rule_id = Digest::SHA1.hexdigest(message)
          end

          yield details[:line].to_i, rule_id, message
        end

        # ESLint results is like below:
        # https://eslint.org/docs/developer-guide/working-with-custom-formatters#the-results-object
        def parse_result(stdout)
          JSON.parse(stdout, symbolize_names: true).flat_map do |issue|
            path = relative_path(issue[:filePath])
            # ESLint informs errors as an array if ESLint detects errors in a file.
            issue[:messages].flat_map do |details|
              issue_parameters(details) do |line, id, message|
                loc = NodeHarness::Location.new(
                  start_line: line,
                  start_column: nil,
                  end_line: nil,
                  end_column: nil
                )
                NodeHarness::Issues::Text.new(
                  path: path,
                  location: loc,
                  id: id,
                  message: message,
                  links: []
                )
              end
            end
          end
        end

        def run_analyzer(target_dir, additional_options)
          # NOTE: eslint exit with status code 1 when some issues are found.
          #       We use `capture3` instead of `capture3!`
          #
          # NOTE: with `--output-file=FILE` option, eslint output FILE file if some issues are found.
          #       When FILE is not created and status is 0, no issues are found.
          #       When FILE is not created and status is 1, Unhandled error has occurred.
          #
          # NOTE: ESLint v5 returns 2 as exit status when fatal error is occurred.
          #       However, this runner doesn't depends on this behavior because it also supports ESLint v4
          output = working_dir + 'output.json'


          stdout, stderr, status = capture3(
            nodejs_analyzer_bin,
            '--format=json',
            '--no-color',
            "--output-file=#{output}",
            *additional_options,
            *target_dir
          )
          # Print text of output.txt for debug
          if output.file?
            output_json = output.read
            trace_writer.message 'Created output.json.'
          end

          if status.success? || output_json
            NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
              parse_result(output_json).each { |v| result.add_issue(v) } if output_json
            end
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
