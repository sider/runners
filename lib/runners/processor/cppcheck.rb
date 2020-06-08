module Runners
  class Processor::Cppcheck < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!(
          target: enum?(string, array(string)),
          ignore: enum?(string, array(string)),
          addon: enum?(string, array(string)),
          enable: string?,
          std: string?,
          project: string?,
          language: string?,
          'bug-hunting': boolean?
        )
      }

      let :rule, object(
        severity: string,
        verbose: string?,
        inconclusive: boolean,
        cwe: string?,
        location_info: string?,
      )
    end

    register_config_schema(name: :cppcheck, schema: Schema.runner_config)

    DEFAULT_TARGET = ".".freeze
    DEFAULT_IGNORE = [].freeze

    def analyze(_changes)
      run_analyzer
    end

    private

    def target
      Array(config_linter[:target] || DEFAULT_TARGET)
    end

    def ignore
      Array(config_linter[:ignore] || DEFAULT_IGNORE).map { |i| ["-i", i] }.flatten
    end

    def addon
      Array(config_linter[:addon] || []).map { |config| "--addon=#{config}" }.flatten
    end

    def enable
      id = config_linter[:enable]
      Array(id ? "--enable=#{id}" : nil)
    end

    def std
      id = config_linter[:std]
      Array(id ? "--std=#{id}" : nil)
    end

    def project
      file = config_linter[:project]
      Array(file ? "--project=#{file}" : nil)
    end

    def language
      lang = config_linter[:language]
      Array(lang ? "--language=#{lang}" : nil)
    end

    def bug_hunting
      Array(do_bug_hunting? ? "--bug-hunting" : nil)
    end

    def do_bug_hunting?
      return config_linter[:'bug-hunting']
    end

    def run_analyzer
      results = Results::Success.new(guid: guid, analyzer: analyzer)

      args_normal = [*enable, *std, *addon]
      args_bughunting = do_bug_hunting? ? [ *bug_hunting ] : nil

      [args_normal, args_bughunting].compact.each do |args|
        ret = step_analyzer(results, *args)
        if ret
          return ret
        end
      end

      return results
    end

    def step_analyzer(results, *args)
      stdout, stderr, status = capture3(
        analyzer_bin,
        "--quiet",
        "--xml",
        *ignore,
        *project,
        *language,
        *args,
        *target
      )

      if status.exitstatus == 1 && stdout.strip == "cppcheck: error: could not find or open any of the paths given."
        add_warning "No linting files."
        return Results::Success.new(guid: guid, analyzer: analyzer)
      end

      unless status.success?
        message = stdout.strip
        message = stderr.strip if message.empty?
        message = "An unexpected error occurred. See the analysis log." if message.empty?
        return Results::Failure.new(guid: guid, analyzer: analyzer, message: message)
      end

      xml_output = REXML::Document.new(stderr)

      unless xml_output.root
        return Results::Failure.new(guid: guid, analyzer: analyzer, message: "Invalid XML output!")
      end

      results.tap do |result|
        parse_result(xml_output) do |issue|
          result.add_issue issue
        end
      end

      return nil # return nil to indicate normal exit
    end

    # @see https://github.com/danmar/cppcheck/blob/master/man/manual.md#xml-output
    def parse_result(xml_doc)
      xml_doc.root.each_element("errors/error") do |err|
        err.each_element("location") do |loc|
          yield Issue.new(
            id: err[:id],
            path: relative_path(loc[:file]),
            location: Location.new(start_line: loc[:line]),
            message: err[:msg],
            object: {
              severity: err[:severity],
              verbose: err[:verbose] != err[:msg] ? err[:verbose] : nil,
              inconclusive: err[:inconclusive] == "true",
              cwe: err[:cwe],
              location_info: loc[:info] != err[:msg] ? loc[:info] : nil,
            },
            schema: Schema.rule,
          )
        end
      end
    end
  end
end
