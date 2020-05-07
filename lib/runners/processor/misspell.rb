module Runners
  class Processor::Misspell < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                        exclude: array?(string),
                        targets: array?(string),
                        locale: enum?(literal('US'), literal('UK')),
                        ignore: string?,
                        # DO NOT ADD ANY OPTIONS under `options`.
                        options: optional(object(
                                            locale: enum?(literal('US'), literal('UK')),
                                            ignore: string?
                                          ))
                      })
      }
    end

    register_config_schema(name: :misspell, schema: Schema.runner_config)

    def analyzer_version
      @analyzer_version ||= extract_version! analyzer_bin, '-v'
    end

    def setup
      add_warning_if_deprecated_options([:options])
      yield
    end

    def analyze(_changes)
      delete_targets
      run_analyzer
    end

    private

    def run_analyzer
      # NOTE: Prevent command injection with `'--'`.
      stdout, _stderr, _status = capture3!(analyzer_bin, *locale, *ignore, '--', *analysis_targets)

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        stdout.split("\n").each do |line|
          match = line.match(/^(?<file>.+):(?<line>\d+):(?<col>\d+): (?<message>"(?<misspell>.+)" is a misspelling of ".+")$/)
          lineno = match[:line].to_i
          col = match[:col].to_i
          misspell = match[:misspell]
          message = match[:message]

          file = match[:file]
          loc = Location.new(
            start_line: lineno,
            start_column: col,
            end_line: lineno,
            end_column: col + misspell.size,
          )
          result.add_issue Issue.new(
            path: relative_path(file),
            location: loc,
            id: message,
            message: message,
          )
        end
      end
    end

    def locale
      locale = config_linter[:locale] || config_linter.dig(:options, :locale)
      locale ? ["-locale", "#{locale}"] : []
    end

    def ignore
      # The option requires comma separated with string when user would like to set ignore multiple targets.
      ignore = config_linter[:ignore] || config_linter.dig(:options, :ignore)
      ignore ? ["-i", "#{ignore}"] : []
    end

    def analysis_targets
      Array(config_linter[:targets] || '.')
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
