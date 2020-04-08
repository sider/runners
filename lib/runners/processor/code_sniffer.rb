module Runners
  class Processor::CodeSniffer < Processor
    include PHP

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
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

      let :issue, object(
        type: string,
        severity: integer,
        fixable: boolean,
      )
    end

    register_config_schema(name: :code_sniffer, schema: Schema.runner_config)

    def setup
      add_warning_if_deprecated_options([:options])
      add_warning_if_deprecated_options([:version])

      yield
    end

    def analyze(changes)
      run_analyzer additional_options, directory
    end

    private

    def analyzer_bin
      "phpcs"
    end

    def additional_options
      # If a repository doesn't have `sider.yml`, use default configuration with `default_sideci_options` method.
      if config_linter.empty?
        default_sideci_options[:options].map do |k, v|
          "--#{k}=#{v}"
        end
      else
        [standard_option, extensions_option, encoding_option, ignore_option].compact
      end
    end

    def standard_option
      standard = config_linter[:standard] || config_linter.dig(:options, :standard) || default_sideci_options.dig(:options, :standard)
      "--standard=#{standard}"
    end

    def extensions_option
      extensions = config_linter[:extensions] || config_linter.dig(:options, :extensions) || default_sideci_options.dig(:options, :extensions)
      "--extensions=#{extensions}"
    end

    def encoding_option
      encoding = config_linter[:encoding] || config_linter.dig(:options, :encoding)
      "--encoding=#{encoding}" if encoding
    end

    def ignore_option
      ignore = config_linter[:ignore] || config_linter.dig(:options, :ignore)
      "--ignore=#{ignore}" if ignore
    end

    def directory
      config_linter[:dir] || config_linter.dig(:options, :dir) || default_sideci_options[:dir]
    end

    def default_sideci_options
      @default_sideci_options ||=
        case php_framework
        when :CakePHP
          {
            options: {
              standard: 'CakePHP',
              extensions: 'php',
            },
            dir: 'app/',
          }
        when :Symfony
          {
            options: {
              standard: 'Symfony',
              extensions: 'php',
            },
            dir: 'src/',
          }
        else
          {
            options: {
              standard: 'PSR2',
              extensions: 'php',
            },
            dir: './',
          }
        end
    end

    def php_framework
      @php_framework ||= {
        CakePHP: 'lib/Cake/Core/CakePlugin.php',
        Symfony: 'app/SymfonyRequirements.php',
      }.find do |framework, file|
        break framework if (current_dir / file).exist?
      end
    end

    def run_analyzer(options, target)
      output_file = Tempfile.create(["phpcs-", ".json"]).path

      capture3!(
        analyzer_bin,
        '--report=json',
        "--report-json=#{output_file}",
        "-q", # Enable quiet mode. See https://github.com/squizlabs/PHP_CodeSniffer/wiki/Advanced-Usage#quieting-output
        "--runtime-set", "ignore_errors_on_exit", "1", # See https://github.com/squizlabs/PHP_CodeSniffer/wiki/Configuration-Options#ignoring-errors-when-generating-the-exit-code
        "--runtime-set", "ignore_warnings_on_exit", "1", # See https://github.com/squizlabs/PHP_CodeSniffer/wiki/Configuration-Options#ignoring-warnings-when-generating-the-exit-code
        *options,
        target
      )

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        issues = []

        read_output_json(output_file)[:files].each do |path, suggests|
          suggests[:messages].each do |suggest|
            issues << Issue.new(
              path: relative_path(path.to_s),
              location: Location.new(start_line: suggest[:line]),
              id: suggest[:source],
              message: suggest[:message],
              object: {
                type: suggest[:type],
                severity: suggest[:severity],
                fixable: suggest[:fixable],
              },
              schema: Schema.issue,
            )
          end
        end

        issues.uniq { |issue| [issue.path, issue.location, issue.id, issue.message] }.each do |issue|
          result.add_issue issue
        end
      end
    end
  end
end
