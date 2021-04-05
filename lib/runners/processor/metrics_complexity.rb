module Runners
  class Processor::MetricsComplexity < Processor
    include Python

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :issue, object(
        CCN: integer,
      )
    end

    # Set maximum recursion depth for python runtime
    # Python runtime has a stack depth limitation. The default value is 1000.  Lizard violates the limitation when it analyze complex source code files.
    # You can ease the limitation with this parameter.
    #
    # NOTE: The actual limitation is bound to RLIMIT_STACK value. You will face a segmentation fault if you set too large value.
    # See: https://man7.org/linux/man-pages/man3/vlimit.3.html
    #
    # According to a simple experiment, we can expand almost `18000` in a typical x64 linux environment.
    # Result: https://gist.github.com/gnakagaw/4c8336aeab6a6206165627cf4fe0eb96
    MAX_RECURSION_DEPTH = 10000

    def analyzer_bin
      "lizard"
    end

    def analyze(changes)
      capture3!(analyzer_bin,
        '--xml',
        '--max-recursion-depth', MAX_RECURSION_DEPTH.to_s,
        '--output_file', report_file,
        '.')

      file_issues = construct_file_issues(read_report_xml)

      Results::Success.new(guid: guid, analyzer: analyzer, issues: file_issues)
    end

    private

    def construct_file_issues(xml_root)
      issues = []

      xml_root.each_element('//cppncss/measure[@type="File"]/item') do |elem|
        filepath_attr = elem[:name] or raise "Required name: #{elem.inspect}"
        filepath = relative_path(filepath_attr)

        ccn_text = elem.elements[3]&.text or raise "Required text: #{elem.elements[3].inspect}"
        sum_of_CCN = Integer(ccn_text)

        functions_text = elem.elements[4]&.text or raise "Required text: #{elem.elements[4].inspect}"
        functions = Integer(functions_text)

        msg = "The sum of complexity of total #{functions} function(s) is #{sum_of_CCN}."

        issues << Issue.new(
          path: filepath,
          location: nil,
          id: "metrics_file-complexity",
          message: msg,
          object: {
            CCN: sum_of_CCN,
            },
          schema: SCHEMA.issue,
          )
      end

      issues
    end
  end
end
