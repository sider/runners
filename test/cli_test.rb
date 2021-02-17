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
    assert_equal :rubocop, cli.analyzer
    assert_instance_of Runners::Options, cli.options
  end

  class TestProcessor < Runners::Processor
    def analyzer_id
      :rubocop
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
    cli.stub(:processor_class, TestProcessor) do
      cli.run
    end

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
    target = ->(value) { cli.send(:format_duration, value) }

    assert_equal "0.0s", target.(0.0)
    assert_equal "0.0s", target.(0.000123)
    assert_equal "0.123s", target.(0.1234567)
    assert_equal "1s", target.(1.1234567)
    assert_equal "10s", target.(10.1234567)
    assert_equal "16m 40s", target.(1000.1234567)
    assert_equal "2h 46m 40s", target.(10000.1234567)
    assert_equal "27h 46m 40s", target.(100000.1234567)
    assert_equal "27h 46m 40s", target.(100000)
  end

  def test_setup_bugsnag
    ENV["BUGSNAG_API_KEY"] = "key"
    ENV["RUNNERS_VERSION"] = "version"
    ENV["BUGSNAG_RELEASE_STAGE"] = nil

    CLI.new(argv: ["--analyzer=rubocop", "test-guid"], stdout: stdout, stderr: stderr, options_json: options_json)

    assert_equal "key", Bugsnag.configuration.api_key
    assert_equal "version", Bugsnag.configuration.app_version
    assert_nil Bugsnag.configuration.release_stage

    refute_includes ENV, "BUGSNAG_API_KEY"
    refute_includes ENV, "RUNNERS_VERSION"
    refute_includes ENV, "BUGSNAG_RELEASE_STAGE"
  end

  def test_setup_aws
    ENV["AWS_ACCESS_KEY_ID"] = "id"
    ENV["AWS_SECRET_ACCESS_KEY"] = "secret"
    ENV["AWS_REGION"] = nil

    CLI.new(argv: ["--analyzer=rubocop", "test-guid"], stdout: stdout, stderr: stderr, options_json: options_json)

    assert_equal "id", Aws.config[:credentials].access_key_id
    assert_equal "secret", Aws.config[:credentials].secret_access_key
    assert_nil Aws.config[:region]

    refute_includes ENV, "AWS_ACCESS_KEY_ID"
    refute_includes ENV, "AWS_SECRET_ACCESS_KEY"
    refute_includes ENV, "AWS_REGION"
  end
end
