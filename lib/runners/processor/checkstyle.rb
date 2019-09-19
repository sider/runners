module Runners
  class Processor::Checkstyle < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::RunnerConfig.base.update_fields { |fields|
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
    end

    def self.ci_config_section_name
      'checkstyle'
    end

    def checkstyle_args(*args, config:, format:, excludes:, properties:)
      args.unshift("-c", config) if config
      args.unshift("-f", format.to_s) if format
      if excludes
        excludes.each do |exclude|
          case
          when exclude.key?(:string)
            args.unshift("-e", exclude[:string])
          when exclude.key?(:pattern)
            args.unshift("-x", exclude[:pattern])
          end
        end
      end
      args.unshift("-p", properties) if properties

      args
    end

    def jar_path
      ENV["CHECKSTYLE_JAR_PATH"] || "/usr/local/share/checkstyle-all.jar"
    end

    def checkstyle(*args, config: nil, format: nil, excludes: nil, properties: nil)
      capture3("java", "-Duser.country=#{locale.country}", "-Duser.language=#{locale.language}", "-jar", jar_path, "com.puppycrawl.tools.checkstyle.Main", *checkstyle_args(*args, config: config, format: format, excludes: excludes, properties: properties))
    end

    def checkstyle!(*args, config: nil, format: nil, excludes: nil, properties: nil)
      capture3!("java", "-Duser.country=#{locale.country}", "-Duser.language=#{locale.language}", "-jar", jar_path, "com.puppycrawl.tools.checkstyle.Main", *checkstyle_args(*args, config: config, format: format, excludes: excludes, properties: properties))
    end

    def analyzer_version
      @analyzer_version ||= extract_version! "java", ["-jar", jar_path, "--version"]
    end

    def analyzer
      @analyzer ||= Analyzer.new(name: 'checkstyle', version: analyzer_version)
    end

    def analyze(changes)
      ensure_runner_config_schema(Schema.runner_config) do
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

        output, _, _ = checkstyle(*dir, config: config_file, format: :xml, excludes: excludes, properties: properties)

        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          construct_result(result, output)
        end
      end
    end

    def construct_result(result, output)
      document = REXML::Document.new(output)

      document.root.each_element do |element|
        if element.name == "file"
          path = relative_path element["name"]

          element.each_element do |element_|
            case element_.name
            when "error"
              line = element_["line"].to_i
              # Checkstyle tells line=0 if there is no appropriate line for the error.
              # Make the line number `1` instead.
              line = 1 if line == 0

              id = element_["source"] + "#" + Digest::SHA2.hexdigest(element_["message"])[0, 6]
              message = element_["message"]
              severity = element_["severity"]

              next if ignored_severities.include?(severity)

              issue = Issues::Text.new(path: path,
                                                    location: Location.new(start_line: line,
                                                                                        start_column: nil,
                                                                                        end_line: nil,
                                                                                        end_column: nil),
                                                    id: id,
                                                    message: message,
                                                    links: [])

              result.add_issue issue
            when "exception"
              add_warning element_.get_text.value.strip, file: path.to_s
            end
          end
        end
      end
    end

    def configuration
      @configuration ||= ci_section.deep_symbolize_keys
    end

    def config_file
      case configuration[:config] || "google"
      when "sun"
        "/sun_checks.xml"
      when "google"
        "/google_checks.xml"
      else
        configuration[:config]
      end
    end

    def check_directory
      array(configuration[:dir] || ".")
    end

    def excluded_directories
      array(configuration[:exclude]).map do |x|
        case x
        when String
          { string: x }
        else
          x
        end
      end
    end

    def properties_file
      configuration[:properties]
    end

    def locale
      locale_string = configuration[:locale] || "en_US"
      Locale::Tag.parse(locale_string)
    end

    def ignored_severities
      array(configuration[:ignore])
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
