module Runners
  class Processor::Misspell < Processor
    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, base(
        exclude: one_or_more_strings?,
        target: target,
        targets: target, # deprecated
        locale: enum?(literal('US'), literal('UK')),
        ignore: one_or_more_strings?,
      )

      let :issue, object(
        correct: string,
        incorrect: string,
      )
    end

    register_config_schema(name: :misspell, schema: SCHEMA.config)

    DEFAULT_TARGET = ".".freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        target: [src/, test/]
        exclude: ["**/*.min.*"]
        locale: UK
        ignore: [center, behavior]
      YAML
    end

    def extract_version_option
      "-v"
    end

    def setup
      warnings.add_warning_for_deprecated_option(config: config, analyzer: analyzer_id, old: :targets, new: :target)
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
            schema: SCHEMA.issue,
          )
        end
      end
    end

    private

    def cli_args
      ["-o", report_file, *locale, *ignore]
    end

    def locale
      locale = config_linter[:locale]
      locale ? ["-locale", "#{locale}"] : []
    end

    def ignore
      # The option requires comma separated with string when user would like to set ignore multiple targets.
      ignore = comma_separated_list(config_linter[:ignore])
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
