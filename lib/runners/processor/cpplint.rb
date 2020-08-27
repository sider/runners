module Runners
  class Processor::Cpplint < Processor
    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass
      let :runner_config, Runners::Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
          target: enum?(string, array(string)),
          extensions: string?,
          headers: string?,
          filter: string?,
          linelength: integer?,
          exclude: enum?(string, array(string)),
        })
      }

      let :issue, object(
        confidence: string?,
      )
    end

    register_config_schema(name: :cpplint, schema: Schema.runner_config)

    DEFAULT_TARGET = ".".freeze

    def analyze(changes)
      _stdout, stderr, status = capture3 analyzer_bin, *analyzer_options

      if [0, 1].include? status.exitstatus
        xml_output = REXML::Document.new(stderr).root
        if xml_output
          Results::Success.new(guid: guid, analyzer: analyzer, issues: parse_result(xml_output))
        else
          Results::Failure.new(guid: guid, analyzer: analyzer, message: stderr)
        end
      else
        Results::Failure.new(guid: guid, analyzer: analyzer, message: stderr)
      end
    end

    private

    def analyzer_options
      [].tap do |opts|
        opts << "--output" << "junit"
        opts << "--recursive"
        config_linter[:extensions]&.then { |v| opts << "--extensions" << v }
        config_linter[:headers]&.then { |v| opts << "--headers" << v }
        config_linter[:filter]&.then { |v| opts << "--filter" << v }
        config_linter[:linelength]&.then { |v| opts << "--linelength" << v.to_s }
        Array(config_linter[:exclude]).each { |v| opts << "--exclude" << v }
        Array(config_linter[:target] || DEFAULT_TARGET).each { |v| opts << v }
      end
    end

    # Output format:
    #
    #     {line}: {message} [{category}] [{confidence}]
    #
    # Example:
    #
    #     3: Tab found; better to use spaces [whitespace/tab] [1]
    #
    # @see https://github.com/cpplint/cpplint/blob/1.5.2/cpplint.py#L1396
    # @see https://github.com/cpplint/cpplint/blob/1.5.2/cpplint.py#L1686-L1693
    def parse_result(xml_root)
      issue_pattern = /^([^:]+): (.+) \[(.+)\] \[(.+)\]$/
      issues = []

      xml_root.each_element("testcase") do |testcase|
        filename = testcase[:name] or raise "Required name: #{testcase.inspect}"
        path = relative_path(filename)

        testcase.each_element("failure") do |failure|
          result = failure.text or raise "Required result: #{failure.inspect}"
          result.scan(issue_pattern) do |match|
            line, message, category, confidence = match
            no_line_number = (line == "0" || !line.match?(/\A\d+\z/))
            issues << Issue.new(
              id: category,
              path: path,
              location: no_line_number ? nil : Location.new(start_line: line),
              message: message.strip,
              object: {
                confidence: confidence,
              },
              schema: Schema.issue,
            )
          end
        end
      end

      issues
    end
  end
end
