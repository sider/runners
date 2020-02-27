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

    def self.ci_config_section_name
      'misspell'
    end

    def analyzer_name
      'Misspell'
    end

    def analyzer_version
      @analyzer_version ||= extract_version! analyzer_bin, '-v'
    end

    def setup
      add_warning_if_deprecated_options([:options], doc: "https://help.sider.review/tools/others/misspell")
      yield
    end

    def analyze(_changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        delete_targets(config)
        check_runner_config(config) do |options, targets|
          run_analyzer(options, targets)
        end
      end
    end

    private

    def check_runner_config(config)
      # Misspell options
      locale = locale(config)
      ignore = ignore(config)

      # Target files for analysis.
      targets = analysis_targets(config)

      yield [locale, ignore].flatten.compact, targets
    end

    def run_analyzer(options, targets)
      # NOTE: Prevent command injection with `'--'`.
      stdout, _stderr, _status = capture3!(analyzer_bin, *options, '--', *targets)

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

    def locale(config)
      locale = config[:locale] || config.dig(:options, :locale)
      ["-locale", "#{locale}"] if locale
    end

    def ignore(config)
      # The option requires comma separeted with string when user would like to set ignore multiple targets.
      ignore = config[:ignore] || config.dig(:options, :ignore)
      ["-i", "#{ignore}"] if ignore
    end

    def analysis_targets(config)
      Array(config[:targets] || '.')
    end

    def delete_targets(config)
      exclude_targets = Array(config[:exclude])
      return if exclude_targets.empty?
      trace_writer.message "Excluding #{exclude_targets.join(', ')} ..." do
        paths = exclude_targets.flat_map { |target| Dir.glob(working_dir + target.to_s) }.uniq
        FileUtils.rm_r(paths, secure: true)
      end
    end
  end
end
