module Runners
  class Processor::Checkstyle < Processor
    include Java

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                        config: string?,
                        dir: optional(enum(string, array(string))),
                        exclude: optional(enum(
                                            string,
                                            array(enum(
                                                    string,
                                                    object(pattern: string),
                                                    object(string: string)
                                                  ))
                                          )),
                        ignore: array?(string),
                        properties: string?
                      })
      }

      let :issue, object(
        severity: string?,
      )
    end

    register_config_schema(name: :checkstyle, schema: Schema.runner_config)

    def analyze(changes)
      analyzer_version

      delete_unchanged_files(changes, only: ["*.java"])

      config_file = config_file()
      trace_writer.message("Using configuration: #{config_file}")

      dir = check_directory()
      trace_writer.message("Checking directory: #{dir}")

      excludes = excluded_directories()
      trace_writer.message("Excluded directories: #{excludes.map { |x|
        case
        when x[:string]
          "string(#{x[:string]})"
        when x[:pattern]
          "pattern(#{x[:pattern]})"
        end
      }.join(", ")}") unless excludes.empty?

      properties = properties_file()
      trace_writer.message("Properties file: #{properties}") if properties

      stdout, stderr, _ = capture3(analyzer_bin, *dir, *checkstyle_args(config: config_file, excludes: excludes, properties: properties))

      begin
        xml_root = REXML::Document.new(stdout).root
      rescue REXML::ParseException => exn
        message = exn.message
        trace_writer.error "Invalid XML output: #{message}"
        return Results::Failure.new(guid: guid, analyzer: analyzer, message: message)
      end

      if xml_root
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          construct_result(xml_root) do |issue|
            result.add_issue(issue)
          end
        end
      else
        message = stdout.empty? ? stderr.lines.first : stdout
        Results::Failure.new(guid: guid, analyzer: analyzer, message: message.strip)
      end
    end

    private

    def checkstyle_args(config:, excludes:, properties:)
      [].tap do |args|
        args << "-f" << "xml"
        args << "-c" << config if config
        excludes.each do |exclude|
          case
          when exclude.key?(:string)
            args << "-e"<< exclude[:string]
          when exclude.key?(:pattern)
            args << "-x" << exclude[:pattern]
          end
        end
        args << "-p" << properties if properties
      end
    end

    def construct_result(xml_root)
      xml_root.each_element("file") do |file|
        path = relative_path file[:name]

        file.each_element do |error|
          case error.name
          when "error"
            severity = error[:severity]
            next if ignored_severities.include?(severity)

            line = error[:line]
            message = error[:message]
            id = error[:source] + "#" + Digest::SHA2.hexdigest(message)[0, 6]

            yield Issue.new(
              path: path,
              location: line == "0" || line.nil? ? nil : Location.new(start_line: line),
              id: id,
              message: message,
              links: build_links(error[:source]),
              object: { severity: severity },
              schema: Schema.issue,
            )
          when "exception"
            add_warning element_.get_text.value.strip, file: path.to_s
          end
        end
      end
    end

    def build_links(rule_id)
      prefix = "com.puppycrawl.tools.checkstyle.checks."
      return [] unless rule_id.start_with?(prefix)

      category, id = rule_id.delete_prefix(prefix).split(".")
      unless id
        id = category
        category = "misc"
      end
      id.delete_suffix!("Check")

      category = "misc" if category == "indentation"

      ["https://checkstyle.org/config_#{category}.html##{id}"]
    end

    def config_file
      case config_linter[:config] || "google"
      when "sun"
        "/sun_checks.xml"
      when "google"
        "/google_checks.xml"
      else
        config_linter[:config]
      end
    end

    def check_directory
      array(config_linter[:dir] || ".")
    end

    def excluded_directories
      array(config_linter[:exclude]).map do |x|
        case x
        when String
          { string: x }
        else
          x
        end
      end
    end

    def properties_file
      config_linter[:properties]
    end

    def ignored_severities
      array(config_linter[:ignore])
    end

    def array(value)
      case value
      when Hash
        [value]
      else
        Array(value)
      end
    end
  end
end
