module Runners
  class Processor::Checkstyle < Processor
    include Java

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, java(
        config: string?,
        target: target,
        dir: target, # alias for `target`
        exclude: enum?(
          string,
          array(enum(string, object(pattern: string), object(string: string))),
        ),
        ignore: one_or_more_strings?,
        properties: string?,
      )

      let :issue, object(
        severity: string?,
      )
    end

    register_config_schema SCHEMA.config

    DEFAULT_TARGET = ".".freeze
    DEFAULT_CONFIG_FILE = (Pathname(Dir.home) / "sider_recommended_checkstyle.xml").to_path.freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        dependencies:
          - "my.company.com:checkstyle-rules:1.0.0"
        config: custom-checkstyle.xml
        target: src/
        exclude: vendor/
        ignore: [warning, info]
        properties: custom-checkstyle.properties
      YAML
    end

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

      target = Array(config_linter[:target] || config_linter[:dir] || DEFAULT_TARGET)
      capture3(analyzer_bin, *checkstyle_args, *target)

      xml_root =
        begin
          read_report_xml
        rescue InvalidXML
          return Results::Failure.new(guid: guid, analyzer: analyzer,
                                      message: "Analysis failed. See the log for details.")
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
          when exclude[:string]
            args << "--exclude" << exclude[:string]
          when exclude[:pattern]
            args << "--exclude-regexp" << exclude[:pattern]
          end
        end

        config_linter[:properties]&.tap do |properties|
          args << "-p" << properties
        end
      end
    end

    def construct_result(xml_root)
      ignored_severities = Array(config_linter[:ignore])

      xml_root.each_element("file") do |file|
        file_name = file[:name] or raise "Invalid file: #{file.inspect}"
        path = relative_path file_name

        file.each_element do |error|
          case error.name
          when "error"
            severity = error[:severity]
            next if ignored_severities.include?(severity)

            line = error[:line]
            id = error[:source] or raise "Required id: #{error.inspect}"
            msg = error[:message] or raise "Required message: #{error.inspect}"

            yield Issue.new(
              path: path,
              location: line == "0" || line.nil? ? nil : Location.new(start_line: line, start_column: error[:column]),
              id: normalize_id(id),
              message: msg,
              links: build_links(id),
              object: { severity: severity },
              schema: SCHEMA.issue,
            )
          when "exception"
            exception = error.text or raise "Required exception: #{error.inspect}"
            add_warning exception, file: path.to_s
          end
        end
      end
    end

    OFFICIAL_RULE_NAMESPACE = "com.puppycrawl.tools.checkstyle.checks."

    def normalize_id(rule_id)
      if rule_id.start_with?(OFFICIAL_RULE_NAMESPACE)
        rule_id.split(".").last or raise "Invalid rule ID: #{rule_id.inspect}"
      else
        rule_id
      end
    end

    def build_links(rule_id)
      prefix = OFFICIAL_RULE_NAMESPACE
      return [] unless rule_id.start_with?(prefix)

      category, id = rule_id.delete_prefix(prefix).split(".")
      unless category
        raise "Required category: #{rule_id.inspect}"
      end
      unless id
        id = category
        category = "misc"
      end
      id.delete_suffix!("Check")

      category = "misc" if category == "indentation"

      ["https://checkstyle.org/config_#{category}.html##{id}"]
    end

    def config_file
      file = config_linter[:config] || "sider"
      case file
      when "sun"
        "/sun_checks.xml"
      when "google"
        "/google_checks.xml"
      when "sider"
        DEFAULT_CONFIG_FILE
      else
        file
      end
    end

    def excluded_directories
      Array(config_linter[:exclude]).map do |dir|
        case dir
        when String
          { string: dir }
        else
          dir
        end
      end
    end
  end
end
