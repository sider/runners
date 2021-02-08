module Runners
  class Processor::Misspell < Processor
    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                        exclude: array?(string),
                        targets: array?(string),
                        target: enum?(string, array(string)),
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

    def extract_version_option
      "-v"
    end

    def setup
      add_warning_if_deprecated_options
      add_warning_for_deprecated_option :targets, to: :target
      yield
    end

    def analyze(_changes)
      delete_targets

      # NOTE: Prevent command injection with `'--'`.
      capture3!(analyzer_bin, *cli_args, '--', *analysis_targets)

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        pattern = /^(?<file>.+):(?<line>\d+):(?<col>\d+): (?<message>"(?<incorrect>.+)" is a misspelling of "(?<correct>.+)")$/
        read_report_file.scan(pattern) do |file, line, col, message, incorrect, correct|
          raise "Unexpected match data: #{file.inspect}" unless file.is_a? String
          raise "Unexpected match data: #{file.inspect}" unless col.is_a? String
          raise "Unexpected match data: #{file.inspect}" unless message.is_a? String
          raise "Unexpected match data: #{file.inspect}" unless incorrect.is_a? String

          result.add_issue Issue.new(
            path: relative_path(file),
            location: Location.new(
              start_line: line,
              start_column: col,
              end_line: line,
              end_column: Integer(col) + incorrect.size,
            ),
            id: correct,
            message: message,
            object: { correct: correct, incorrect: incorrect },
            schema: Schema.issue,
          )
        end
      end
    end

    private

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
        paths = exclude_targets.flat_map do |target|
          # @type var target: String
          working_dir.glob(target)
        end.uniq
        FileUtils.rm_rf(paths, secure: true)
      end
    end
  end
end
