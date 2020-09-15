module Runners
  class Processor::Pylint < Processor
    include Python

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
          target: enum?(string, array(string)),
          rcfile: string?,
          ignore: enum?(string, array(string)),
          'errors-only': boolean?,
        })
      }

      let :rule, object(
        severity: string,
        'message-id': string,
        module: string,
        obj: string,
      )
    end

    register_config_schema(name: :pylint, schema: Schema.runner_config)

    DEFAULT_TARGET = ["**/*.{py}"].freeze

    def analyze(changes)
      run_analyzer
    end

    private

    def rcfile
      config_linter[:rcfile].then { |file| file ? ["--rcfile=#{file}"] : [] }
    end

    def ignore
      Array(config_linter[:ignore] || []).then { |arr| arr.empty? ? nil : "--ignore=#{arr.join(",")}" }
    end

    def erros_only
      config_linter[:'errors-only'].then { |value| value ? ["--errors-only"] : [] }
    end

    def analyzed_files
      # Via glob
      targets = Array(config_linter[:target] || DEFAULT_TARGET)
      globs = targets.select { |glob| glob.is_a? String }
      Dir.glob(globs, File::FNM_EXTGLOB, base: current_dir)
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
          schema: Schema.rule,
        )
      end
    end

    def run_analyzer
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

  end
end
