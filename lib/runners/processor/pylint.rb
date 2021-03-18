module Runners
  class Processor::Pylint < Processor
    include Python

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, base(
        target: target,
        rcfile: string?,
        ignore: one_or_more_strings?,
        'errors-only': boolean?,
      )

      let :issue, object(
        severity: string,
        'message-id': string,
        module: string,
        obj: string,
      )
    end

    register_config_schema(name: :pylint, schema: SCHEMA.config)

    DEFAULT_TARGET = ["**/*.{py}"].freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        target:
          - "src/**/*.py"
          - "test/**/*.py"
        rcfile: config/.pylintrc
        errors-only: true
        ignore:
          - src/ignored.py
          - test/ignored.py
      YAML
    end

    def analyze(_changes)
      files = analyzed_files

      if files.empty?
        trace_writer.message "No files found."
        return Results::Success.new(guid: guid, analyzer: analyzer)
      end

      trace_writer.message "Analyzing #{files.size} file(s)..."

      stdout, stderr = capture3!(
        analyzer_bin,
        *files,
        *rcfile,
        *ignore,
        *erros_only,
        '--output-format=json',
        # NOTE: If jobs option is not 1, the output is different
        # @see https://github.com/PyCQA/pylint/issues/374
        '--jobs=1',
        '--exit-zero',
        # NOTE: We don't support importing modules yet.
        # @see http://pylint.pycqa.org/en/stable/technical_reference/features.html#imports-checker-messages
        '--disable=import-error',
      )

      return Results::Failure.new(guid: guid, analyzer: analyzer) unless stderr.empty?

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        parse_result(stdout) do |issue|
          result.add_issue issue
        end
      end
    end

    private

    def rcfile
      config_linter[:rcfile].then { |file| file ? ["--rcfile=#{file}"] : [] }
    end

    def ignore
      Array(config_linter[:ignore] || []).then { |arr| arr.empty? ? [] : ["--ignore=#{arr.join(",")}"] }
    end

    def erros_only
      config_linter[:'errors-only'].then { |value| value ? ["--errors-only"] : [] }
    end

    def analyzed_files
      targets = Array(config_linter[:target] || DEFAULT_TARGET)
      Dir.glob(targets, File::FNM_EXTGLOB, base: current_dir.to_path)
    end

    def parse_result(output)
      json = JSON.parse(output, symbolize_names: true)
      json.flat_map do |issue|
        yield Issue.new(
          id: issue[:symbol],
          path: relative_path(issue[:path]),
          location: Location.new(start_line: issue[:line], start_column: issue[:column]),
          message: issue[:message],
          object: {
            severity: issue[:type],
            'message-id': issue[:'message-id'],
            module: issue[:module],
            obj: issue[:obj],
          },
          schema: SCHEMA.issue,
        )
      end
    end
  end
end
