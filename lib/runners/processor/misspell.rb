module Runners
  class Processor::Misspell < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                        exclude: array?(string),
                        targets: array?(string),
                        target: array?(string),
                        locale: enum?(literal('US'), literal('UK')),
                        ignore: enum?(string, array(string)),
                        # DO NOT ADD ANY OPTIONS under `options`.
                        options: optional(object(
                                            locale: enum?(literal('US'), literal('UK')),
                                            ignore: string?
                                          ))
                      })
      }

      let :issue, object(
        correct: string,
        incorrect: string,
      )
    end

    register_config_schema(name: :misspell, schema: Schema.runner_config)

    DEFAULT_TARGET = ".".freeze

    def analyzer_version
      @analyzer_version ||= extract_version! analyzer_bin, '-v'
    end

    def setup
      add_warning_if_deprecated_options
      add_warning_for_deprecated_option :targets, to: :target
      yield
    end

    def analyze(_changes)
      delete_targets
      run_analyzer
    end

    private

    def run_analyzer
      # NOTE: Prevent command injection with `'--'`.
      capture3!(analyzer_bin, *cli_args, '--', *analysis_targets)

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        read_report_file.each_line do |line|
          match = line.match(/^(?<file>.+):(?<line>\d+):(?<col>\d+): (?<message>"(?<incorrect>.+)" is a misspelling of "(?<correct>.+)")$/)
          lineno = Integer(match[:line])
          col = Integer(match[:col])
          correct = match[:correct]
          incorrect = match[:incorrect]

          result.add_issue Issue.new(
            path: relative_path(match[:file]),
            location: Location.new(
              start_line: lineno,
              start_column: col,
              end_line: lineno,
              end_column: col + incorrect.size,
            ),
            id: correct,
            message: match[:message],
            object: { correct: correct, incorrect: incorrect },
            schema: Schema.issue,
          )
        end
      end
    end

    def cli_args
      ["-o", report_file, *locale, *ignore]
    end

    def locale
      locale = config_linter[:locale] || config_linter.dig(:options, :locale)
      locale ? ["-locale", "#{locale}"] : []
    end

    def ignore
      # The option requires comma separated with string when user would like to set ignore multiple targets.
      ignore = comma_separated_list(config_linter[:ignore] || config_linter.dig(:options, :ignore))
      ignore ? ["-i", ignore] : []
    end

    def analysis_targets
      Array(config_linter[:target] || config_linter[:targets] || DEFAULT_TARGET)
    end

    def delete_targets
      exclude_targets = Array(config_linter[:exclude])
      return if exclude_targets.empty?
      trace_writer.message "Excluding #{exclude_targets.join(', ')} ..." do
        paths = exclude_targets.flat_map { |target| Dir.glob(working_dir + target.to_s) }.uniq
        FileUtils.rm_r(paths, secure: true)
      end
    end
  end
end
