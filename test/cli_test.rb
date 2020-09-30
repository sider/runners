require "test_helper"
require "runners/cli"

class CLITest < Minitest::Test
  include TestHelper

  CLI = Runners::CLI
  TraceWriter = Runners::TraceWriter

  def stdout
    @stdout ||= StringIO.new
  end

  def stderr
    @stderr ||= StringIO.new
  end

  def options_json(options = { source: new_source })
    JSON.dump(options)
  end

  def test_parsing_options
    cli = CLI.new(argv: ["--analyzer=rubocop", "test-guid"], stdout: stdout, stderr: stderr, options_json: options_json)
    assert_equal "test-guid", cli.guid
    assert_equal 'rubocop', cli.analyzer
    assert_instance_of Runners::Options, cli.options
  end

  def test_validate_options
    assert_raises OptionParser::MissingArgument do
      CLI.new(argv: ["test-guid"], stdout: stdout, stderr: stderr, options_json: options_json)
    end.tap do |error|
      assert_equal "missing argument: --analyzer is required", error.message
    end

    assert_raises RuntimeError do
      CLI.new(argv: ["--analyzer=FOO", "test-guid"], stdout: stdout, stderr: stderr, options_json: options_json)
    end.tap do |error|
      assert_equal "Not found processor class with 'FOO'", error.message
    end

    assert_raises OptionParser::MissingArgument do
      CLI.new(argv: ["--analyzer=rubocop"], stdout: stdout, stderr: stderr, options_json: options_json)
    end.tap do |error|
      assert_equal "missing argument: GUID is required", error.message
    end
  end

  class TestProcessor < Runners::Processor
    def analyzer_id
      "rubocop"
    end

    def analyzer_version
      "1.2.3"
    end

    def setup
      yield
    end

    def analyze(changes)
      trace_writer.command_line ["test", "command"]
      trace_writer.status Struct.new(:exitstatus).new(31)

      add_warning('hogehogewarn')

      Runners::Results::Success.new(guid: guid, analyzer: analyzer)
    end
  end

  def test_run
    cli = CLI.new(argv: ["--analyzer=rubocop", "test-guid"], stdout: stdout, stderr: stderr, options_json: options_json)
    cli.instance_variable_set(:@processor_class, TestProcessor)
    cli.run

    # It write JSON objects to stdout

    output = stdout.string
    reader = JSONSEQ::Reader.new(io: StringIO.new(output), decoder: -> (string) { JSON.parse(string, symbolize_names: true) })
    objects = reader.each_object.to_a

    assert objects.any? { |hash| hash[:trace] == 'command_line' && hash[:command_line] == ["test", "command"] }
    assert objects.any? { |hash| hash[:trace] == 'status' && hash[:status] == 31 }
    assert objects.any? { |hash| hash[:trace] == 'warning' && hash[:message] == 'hogehogewarn' }
    assert objects.any? { |hash| hash[:warnings] == [{ message: 'hogehogewarn', file: nil }] }
    assert objects.any? { |hash| hash[:ci_config] == { linter: nil, ignore: [], branches: nil } }
  end

  def test_run_when_sider_yml_is_broken
    json = options_json({ source: new_source(head: "07aeaa0b17fb34063cbc3ed24d6d65f986c37884") })
    cli = CLI.new(argv: ["--analyzer=rubocop", "test-guid"], stdout: stdout, stderr: stderr, options_json: json)
    cli.instance_variable_set(:@processor_class, TestProcessor)
    cli.run

    # It write JSON objects to stdout

    output = stdout.string
    reader = JSONSEQ::Reader.new(io: StringIO.new(output), decoder: -> (string) { JSON.parse(string, symbolize_names: true) })
    objects = reader.each_object.to_a

    assert objects.any? { |hash| hash.dig(:result, :type) == 'failure' }
    assert objects.any? { |hash| hash[:warnings] == [] }
    assert objects.any? { |hash| hash[:ci_config] == nil }
  end

  def test_format_duration
    cli = CLI.new(argv: ["--analyzer=rubocop", "test-guid"], stdout: stdout, stderr: stderr, options_json: options_json)
    assert_equal "0.0s", cli.format_duration(0.0)
    assert_equal "0.0s", cli.format_duration(0.000123)
    assert_equal "0.123s", cli.format_duration(0.1234567)
    assert_equal "1s", cli.format_duration(1.1234567)
    assert_equal "10s", cli.format_duration(10.1234567)
    assert_equal "16m 40s", cli.format_duration(1000.1234567)
    assert_equal "2h 46m 40s", cli.format_duration(10000.1234567)
    assert_equal "27h 46m 40s", cli.format_duration(100000.1234567)
    assert_equal "27h 46m 40s", cli.format_duration(100000)
  end
end
