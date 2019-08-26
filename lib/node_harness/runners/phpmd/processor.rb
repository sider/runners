module NodeHarness
  module Runners
    module Phpmd
      class Processor < NodeHarness::Processor
        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.base.update_fields { |fields|
            fields.merge!({
                            target: enum?(string, array(string)),
                            rule: string?,
                            minimumpriority: numeric?,
                            suffixes: string?,
                            exclude: string?,
                            strict: boolean?,
                            # DO NOT ADD ANY OPTIONS in `options` option.
                            options: optional(object(
                                                rule: string?,
                                                minimumpriority: numeric?,
                                                suffixes: string?,
                                                exclude: string?,
                                                strict: boolean?
                                              ))
                          })
          }
        end

        def self.ci_config_section_name
          # Section name in sideci.yml, Generally it is the name of analyzer tool.
          "phpmd"
        end

        def analyzer
          @analyzer ||= begin
            stdout, _, = capture3!('phpmd', '--version')
            # stdout: "PHPMD 2.4.3"
            version = stdout.strip.scan(/PHPMD\s([0-9\.]+)/).flatten.first
            NodeHarness::Analyzer.new(name: "phpmd", version: version)
          end
        end

        def analyze(changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            capture3!('phpmd', '--version')
            prepare_analysis_files(changes)

            check_runner_config(config) do |targets, rule, options|
              run_analyzer(changes, targets, rule, options)
            end
          end
        end

        private

        def prepare_analysis_files(changes)
          delete_unchanged_files(changes, only: ["*.php"])

          trace_writer.message "Changed files:" do
            changes.changed_files.each do |file|
              trace_writer.message "  * #{file.path}"
            end
          end

          trace_writer.message "Untracked files:" do
            changes.untracked_paths.each do |path|
              trace_writer.message "  * #{path}"
            end
          end

          trace_writer.message "Existing files:" do
            capture3('find', '.')
          end
        end

        def check_runner_config(config)
          # Options which have default values.
          targets = target_dirs(config)
          rule = rule(config)

          # Additional options.
          options = [minimumpriority(config), suffixes(config), exclude(config), strict(config)].flatten

          yield targets, rule, options
        end

        def rule(config)
          rules = config[:rule] || config.dig(:options, :rule)
          if rules
            rules
          else
            # NOTE: It assumes that default config xml is located in $HOME
            (Pathname(Dir.home) / 'sider_config.xml').realpath.to_s
          end
        end

        def target_dirs(config)
          Array(config[:target] || './').flat_map { |target| target.split(',') }.join(',')
        end

        def minimumpriority(config)
          min_priority = config[:minimumpriority] || config.dig(:options, :minimumpriority)
          min_priority ? ["--minimumpriority", "#{min_priority}"] : []
        end

        def suffixes(config)
          suffixes = config[:suffixes] || config.dig(:options, :suffixes)
          suffixes ? ["--suffixes", "#{suffixes}"] : []
        end

        def exclude(config)
          exclude = config[:exclude] || config.dig(:options, :exclude)
          exclude ? ["--exclude", "#{exclude}"] : []
        end

        def strict(config)
          strict = config[:strict] || config.dig(:options, :strict)
          strict ? ["--strict"] : []
        end

        def run_analyzer(changes, targets, rule, options)
          # PHPMD exits 1 when some violations are found.
          # The `--ignore-violation-on-exit` will exit with a zero code, even if any violations are found.
          # See. https://phpmd.org/documentation/index.html
          command_args = [targets, 'xml', rule, '--ignore-violations-on-exit'] + options
          stdout, _ = capture3!('phpmd', *command_args)

          change_paths = changes.changed_files.map(&:path)
          errors = Nokogiri::XML(stdout).xpath('/pmd/error').select do |error|
            change_paths.include?(relative_path(error['filename']))
          end
          unless errors.empty?
            messages = errors.map { |error| error['msg'] }
            messages.each { |message| trace_writer.error message }
            return NodeHarness::Results::Failure.new(guid: guid, message: messages.join("\n"), analyzer: analyzer)
          end

          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            Nokogiri::XML(stdout).xpath('/pmd/file').map do |file|
              file.xpath('violation').map do |violation|
                loc = NodeHarness::Location.new(
                  start_line: violation['beginline'].to_i,
                  start_column: nil,
                  end_line: violation['endline'].to_i,
                  end_column: nil
                )

                result.add_issue NodeHarness::Issues::Text.new(
                  path: relative_path(file['name']),
                  location: loc,
                  id: violation['rule'],
                  message: violation.content.strip,
                  links: [violation['externalInfoUrl']]
                )
              end
            end
          end
        end
      end
    end
  end
end
