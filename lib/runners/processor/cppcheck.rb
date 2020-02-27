module Runners
  class Processor::Cppcheck < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!(
          target: enum?(string, array(string)),
          ignore: enum?(string, array(string)),
          enable: string?,
          std: string?,
          project: string?,
          language: string?,
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

    def self.ci_config_section_name
      "cppcheck"
    end

    def analyzer_name
      "Cppcheck"
    end

    def setup
      analyzer
      yield
    end

    def analyze(_changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        @config = config
        run_analyzer
      end
    end

    private

    def config
      @config or raise "Must be initialized!"
    end

    def target
      Array(config[:target] || DEFAULT_TARGET)
    end

    def ignore
      Array(config[:ignore] || DEFAULT_IGNORE).map { |i| ["-i", i] }.flatten
    end

    def enable
      id = config[:enable]
      Array(id ? "--enable=#{id}" : nil)
    end

    def std
      id = config[:std]
      Array(id ? "--std=#{id}" : nil)
    end

    def project
      file = config[:project]
      Array(file ? "--project=#{file}" : nil)
    end

    def language
      lang = config[:language]
      Array(lang ? "--language=#{lang}" : nil)
    end

    def run_analyzer
      stdout, stderr, status = capture3(
        analyzer_bin,
        "--quiet",
        "--xml",
        *ignore,
        *enable,
        *std,
        *project,
        *language,
        *target,
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

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        parse_result(xml_output) do |issue|
          result.add_issue issue
        end
      end
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
