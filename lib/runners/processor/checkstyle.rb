module Runners
  class Processor::Checkstyle < Processor
    include Java

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.java.update_fields { |fields|
        fields.merge!({
          config: string?,
          dir: enum?(string, array(string)),
          exclude: enum?(
            string,
            array(enum(string, object(pattern: string), object(string: string))),
          ),
          ignore: array?(string),
          properties: string?,
        })
      }

      let :issue, object(
        severity: string?,
      )
    end

    register_config_schema(name: :checkstyle, schema: Schema.runner_config)

    def setup
      begin
        install_jvm_deps
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message)
      end

      yield
    end

    def analyze(changes)
      delete_unchanged_files(changes, only: ["*.java"])

      capture3(analyzer_bin, *check_directory, *checkstyle_args)

      begin
        xml_root = read_report_xml.root
      rescue InvalidXML
        message = "Analysis failed. See the log for details."
        return Results::Failure.new(guid: guid, analyzer: analyzer, message: message)
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        construct_result(xml_root) do |issue|
          result.add_issue(issue)
        end
      end
    end

    private

    def checkstyle_args
      [].tap do |args|
        args << "-f" << "xml"
        args << "-o" << report_file

        config_file&.tap do |config|
          args << "-c" << config
        end

        excluded_directories.each do |exclude|
          case
          when exclude.key?(:string)
            args << "--exclude" << exclude[:string]
          when exclude.key?(:pattern)
            args << "--exclude-regexp" << exclude[:pattern]
          end
        end

        config_linter[:properties]&.tap do |properties|
          args << "-p" << properties
        end
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
            id = error[:source]

            yield Issue.new(
              path: path,
              location: line == "0" || line.nil? ? nil : Location.new(start_line: line, start_column: error[:column]),
              id: normalize_id(id),
              message: error[:message],
              links: build_links(id),
              object: { severity: severity },
              schema: Schema.issue,
            )
          when "exception"
            add_warning element_.get_text.value.strip, file: path.to_s
          end
        end
      end
    end

    OFFICIAL_RULE_NAMESPACE = "com.puppycrawl.tools.checkstyle.checks."

    def normalize_id(rule_id)
      if rule_id.start_with?(OFFICIAL_RULE_NAMESPACE)
        rule_id.split(".").last
      else
        rule_id
      end
    end

    def build_links(rule_id)
      prefix = OFFICIAL_RULE_NAMESPACE
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
      file = config_linter[:config] || "google"
      case file
      when "sun"
        "/sun_checks.xml"
      when "google"
        "/google_checks.xml"
      else
        file
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
