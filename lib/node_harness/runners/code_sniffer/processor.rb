module NodeHarness
  module Runners
    module CodeSniffer
      class Processor < NodeHarness::Processor
        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.base.update_fields { |fields|
            fields.merge!({
                            version: enum?(string, numeric),
                            dir: string?,
                            standard: string?,
                            extensions: string?,
                            encoding: string?,
                            ignore: string?,
                            # DO NOT ADD ANY OPTION under `options`.
                            options: optional(object(
                                                dir: string?,
                                                standard: string?,
                                                extensions: string?,
                                                encoding: string?,
                                                ignore: string?
                                              ))
                          })
          }
        end

        def self.ci_config_section_name
          # Section name in sideci.yml, Generally it is the name of analyzer tool.
          "code_sniffer"
        end

        def analyze(changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            check_runner_config(config) do |phpcs, options, target|
              run_analyzer(phpcs, options, target)
            end
          end
        end

        private

        attr_reader :phpcs_bin

        def check_runner_config(config)
          @phpcs_bin ||=
            case config[:version].to_i
            when 2
              add_warning("Sider has no longer supported PHP_CodeSniffer v2. Sider executes v3 even if putting `2` as `version` option.", file: "sider.yml")
              'phpcs3'
            else
              'phpcs3'
            end
          phpcs = phpcs_bin
          options = additional_options(config)
          target = directory(config)

          yield phpcs, options, target
        end

        def analyzer
          @analyzer ||= begin
            stdout, = capture3!(phpcs_bin, '--version')
            # stdout: "PHP_CodeSniffer version 3.3.0 (stable) by Squiz (http://www.squiz.net)"
            stdout.match(/\s([0-9\.]+)\s/) do |match|
              version = match.captures.first
              if version
                NodeHarness::Analyzer.new(name: "code_sniffer", version: version)
              else
                raise "Not found version: #{stdout.inspect}"
              end
            end
          end
        end

        def additional_options(config)
          # If a repository doesn't have `sideci.yml`, use default configuration with `default_sideci_options` method.
          if config.empty?
            default_sideci_options['options'].map do |k, v|
              "--#{k}=#{v}"
            end
          else
            options = [
              standard_option(config),
              extensions_option(config),
            ]
            encoding_option(config).tap { |opt| options << opt if opt }
            ignore_option(config).tap { |opt| options << opt if opt }
            options
          end
        end

        def standard_option(config)
          standard = config[:standard] || config.dig(:options, :standard) || default_sideci_options['options']['standard']
          "--standard=#{standard}"
        end

        def extensions_option(config)
          extensions = config[:extensions] || config.dig(:options, :extensions) || default_sideci_options['options']['extensions']
          "--extensions=#{extensions}"
        end

        def encoding_option(config)
          encoding = config[:encoding] || config.dig(:options, :encoding)
          "--encoding=#{encoding}" if encoding
        end

        def ignore_option(config)
          ignore = config[:ignore] || config.dig(:options, :ignore)
          "--ignore=#{ignore}" if ignore
        end

        def directory(config)
          config[:dir] ||
            config.dig(:options, :dir)&.tap do
              add_warning("`dir` key under the `options` is deprecated. Please declare it just under the `code_sniffer`. See https://help.sider.review/tools/php/codesniffer#options", file: "sideci.yml")
            end ||
            default_sideci_options['dir']
        end

        def default_sideci_options
          @default_sideci_options ||=
            begin
              case php_framework
              when 'CakePHP'
                standard = 'CakePHP'
                dir = 'app/'
              when 'Symfony'
                standard = 'Symfony'
                dir = 'src/'
              else
                standard = 'PSR2'
                dir = './'
              end

              {
                'options' => {
                  'standard' => standard,
                  'extensions' => 'php',
                },
                'dir' => dir,
              }
            end
        end

        def php_framework
          @php_framework ||=
            begin
              frameworks = {
                'CakePHP' => 'lib/Cake/Core/CakePlugin.php',
                'FuelPHP' => 'oil',
                'CodeIgniter' => 'system/core/CodeIgniter.php',
                'Symfony' => 'app/SymfonyRequirements.php'
              }
              found = frameworks.find do |_, file|
                _, _, status = capture3('test', '-f', file)
                status.success?
              end
              found.first if found
            end
        end

        def print_large_string(str)
          max_size = 24_000
          if str.size <= max_size
            trace_writer.message str
          else
            # NOTE: To avoid stalling, it outputs prefix and suffix only.
            trace_writer.message str[0...(max_size / 2)]
            trace_writer.message '......'
            trace_writer.message str[(str.size - (max_size / 2))...str.size]
          end
        end

        def run_analyzer(phpcs, options, target)
          output = working_dir + 'output.txt'
          # code_sniffer always exists with "statsu = 1" when any warnings exist, so we don't see the status code.
          #
          # Runtime erros such as "directory not found" will be displayed in stdout.
          #
          # Without `--report-json`, if users configure with `<arg name="report" value="summary"/>`,
          # all output is mixed in stdout. So, we have to write output to a file.
          capture3(
            phpcs,
            '--report=json',
            "--report-json=#{output}",
            *options,
            target
          )

          stdout = output.read
          trace_writer.message "Result Output:"
          print_large_string(stdout)

          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            issues = []

            JSON.parse(stdout, symbolize_names: true)[:files].each do |path, suggests|
              suggests[:messages].each do |suggest|
                loc = NodeHarness::Location.new(
                  start_line: suggest[:line].to_i,
                  start_column: nil,
                  end_line: nil,
                  end_column: nil
                )

                issues << NodeHarness::Issues::Text.new(
                  path: relative_path(path.to_s),
                  location: loc,
                  id: suggest[:source],
                  message: suggest[:message],
                  links: []
                )
              end
            end

            issues.uniq { |issue| [issue.path, issue.location, issue.id, issue.message] }.each do |issue|
              result.add_issue issue
            end
          end
        rescue JSON::ParserError => exn
          trace_writer.message exn.inspect.truncate(1000)
          NodeHarness::Results::Failure.new(guid: guid,
                                            analyzer: analyzer,
                                            message: "code sniffer output parsing failed")
        end
      end
    end
  end
end
