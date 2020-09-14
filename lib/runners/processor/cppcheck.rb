require "etc"

module Runners
  class Processor::Cppcheck < Processor
    include CPlusPlus

    class NoTargetFiles < SystemError; end

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass
      let :runner_config, Runners::Schema::BaseConfig.cplusplus.update_fields { |fields|
        fields.merge!(
          target: enum?(string, array(string)),
          ignore: enum?(string, array(string)),
          addon: enum?(string, array(string)),
          enable: string?,
          std: string?,
          project: string?,
          language: string?,
          'bug-hunting': boolean?,
          parallel: boolean?,
        )
      }

      let :issue, object(
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
      Array(config_linter[:ignore] || DEFAULT_IGNORE).flat_map { |i| ["-i", i] }
    end

    def addon
      Array(config_linter[:addon] || []).map { |config| "--addon=#{config}" }
    end

    def enable
      config_linter[:enable].then { |id| id ? ["--enable=#{id}"] : [] }
    end

    def std
      config_linter[:std].then { |id| id ? ["--std=#{id}"] : [] }
    end

    def project
      config_linter[:project].then { |file| file ? ["--project=#{file}"] : [] }
    end

    def language
      config_linter[:language].then { |lang| lang ? ["--language=#{lang}"] : [] }
    end

    def jobs
      @jobs ||=
        if config_linter[:parallel]
          if config_linter[:project]
            add_warning <<~MSG, file: config.path_name
              The `parallel` option is ignored when the `project` option is specified.
              This limitation is due to the behavior of #{analyzer_name}.
            MSG
            []
          else
            ["-j", Etc.nprocessors.to_s]
          end
        else
          []
        end
    end

    def run_analyzer
      issues = []

      begin
        ret = step_analyzer(*enable, *std, *addon)
        case ret
        when Results::Success
          issues.push(*ret.issues)
        else
          return ret
        end
      rescue NoTargetFiles
        return Results::Success.new(guid: guid, analyzer: analyzer)
      end

      if config_linter[:'bug-hunting']
        ret = step_analyzer("--bug-hunting")
        case ret
        when Results::Success
          issues.push(*ret.issues)
        else
          return ret
        end
      end

      Results::Success.new(guid: guid, analyzer: analyzer, issues: issues)
    end

    def step_analyzer(*args)
      stdout, stderr, status = capture3(
        analyzer_bin,
        "--quiet",
        "--xml",
        "--output-file=#{report_file}",
        *ignore,
        *project,
        *language,
        *config_include_path,
        *jobs,
        *args,
        *target
      )

      if status.exitstatus == 1 && stdout.strip == "cppcheck: error: could not find or open any of the paths given."
        add_warning "No linting files."
        raise NoTargetFiles
      end

      unless status.success?
        return Results::Failure.new(guid: guid, analyzer: analyzer)
      end

      xml_root =
        begin
          read_report_xml
        rescue InvalidXML
          return Results::Failure.new(guid: guid, analyzer: analyzer, message: "Invalid XML output")
        end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        parse_result(xml_root) do |issue|
          result.add_issue issue
        end
      end
    end

    # @see https://github.com/danmar/cppcheck/blob/master/man/manual.md#xml-output
    def parse_result(xml_root)
      xml_root.each_element("errors/error") do |err|
        id = err[:id] or raise "Required id: #{err.inspect}"
        msg = err[:msg] or raise "Required msg: #{err.inspect}"

        err.each_element("location") do |loc|
          file = loc[:file] or raise "Required file: #{loc.inspect}"
          yield Issue.new(
            id: id,
            path: relative_path(file),
            location: Location.new(start_line: loc[:line], start_column: loc[:column]),
            message: msg,
            object: {
              severity: err[:severity],
              verbose: err[:verbose] != msg ? err[:verbose] : nil,
              inconclusive: err[:inconclusive] == "true",
              cwe: err[:cwe],
              location_info: loc[:info] != msg ? loc[:info] : nil,
            },
            schema: Schema.issue,
          )
        end
      end
    end
  end
end
