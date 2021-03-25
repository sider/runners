require "test_helper"
require "runners/cli"

class CLITest < Minitest::Test
  include TestHelper

  class TestProcessor < Runners::Processor
    def analyzer_id; :rubocop; end
    def analyzer_version; "1.2.3"; end

    def setup
      yield
    end

    def analyze(_)
      trace_writer.command_line ["test", "command"]
      trace_writer.status Struct.new(:exitstatus).new(31)

      add_warning('hogehogewarn')

      Runners::Results::Success.new(guid: guid, analyzer: analyzer)
    end
  end

  def setup
    @tmpdir = mktmpdir.tap { FileUtils.remove_entry_secure(_1) }
  end

  def teardown
    FileUtils.remove_entry_secure @tmpdir
  end

  def test_parsing_options
    cli = new_cli
    assert_equal "test-guid", cli.guid
    assert_equal :rubocop, cli.analyzer
    assert_instance_of Runners::Options, cli.options
  end

  def test_run
    cli = new_cli
    cli.stub(:processor_class, TestProcessor) { cli.run }

    assert traces.any? { _1[:trace] == 'command_line' && _1[:command_line] == ["test", "command"] }
    assert traces.any? { _1[:trace] == 'status' && _1[:status] == 31 }
    assert traces.any? { _1[:trace] == 'warning' && _1[:message] == 'hogehogewarn' }
    assert traces.any? { _1[:warnings] == [{ message: 'hogehogewarn', file: nil }] }
    assert traces.any? { _1[:ci_config] == { linter: nil, ignore: [], branches: nil } }

    assert_equal ["Start analysis", "Set up source code", "Set up RuboCop", "Run RuboCop", "Finish analysis"],
                 traces.filter_map { _1[:message] if _1[:trace] == "header" }
    assert_includes traces.filter_map { _1[:message] if _1[:trace] == 'message' },
                    "RuboCop analysis succeeded: 0 issues, 1 warnings"
  end

  def test_run_with_one_issue
    klass = Class.new(TestProcessor) do
      def analyze(_)
        issues = [Runners::Issue.new(path: Pathname("sider.yml"), location: nil, id: "a", message: "abc")]
        Runners::Results::Success.new(guid: guid, analyzer: analyzer, issues: issues)
      end
    end
    cli = new_cli
    cli.stub(:processor_class, klass) { cli.run }

    assert_includes traces.filter_map { _1[:message] if _1[:trace] == 'message' },
                    "RuboCop analysis succeeded: 1 issues, 0 warnings"
  end

  def test_run_with_multiple_issues
    klass = Class.new(TestProcessor) do
      def analyze(_)
        issues = ["a", "b"].map { Runners::Issue.new(path: Pathname("sider.yml"), location: nil, id: _1, message: "abc") }
        Runners::Results::Success.new(guid: guid, analyzer: analyzer, issues: issues)
      end
    end
    cli = new_cli
    cli.stub(:processor_class, klass) { cli.run }

    assert_includes traces.filter_map { _1[:message] if _1[:trace] == 'message' },
                    "RuboCop analysis succeeded: 2 issues, 0 warnings"
  end

  def test_run_with_error
    klass = Class.new(TestProcessor) do
      def analyze(_)
        Runners::Results::Failure.new(guid: guid, analyzer: analyzer)
      end
    end
    cli = new_cli
    cli.stub(:processor_class, klass) { cli.run }

    assert_includes traces.filter_map { _1[:message] if _1[:trace] == 'message' },
                    "RuboCop analysis failed."
  end

  def test_run_with_error_and_no_analyzer
    klass = Class.new(TestProcessor) do
      def analyze(_)
        Runners::Results::Failure.new(guid: guid, analyzer: nil)
      end
    end
    cli = new_cli
    cli.stub(:processor_class, klass) { cli.run }

    assert_includes traces.filter_map { _1[:message] if _1[:trace] == 'message' },
                    "Analysis failed."
  end

  def test_run_with_broken_config
    cli = new_cli(options_json: options_json({ source: new_source(head: "07aeaa0b17fb34063cbc3ed24d6d65f986c37884") }))
    cli.run

    assert traces.any? { _1.dig(:result, :type) == 'failure' }
    assert traces.any? { _1[:warnings] == [] }
    assert traces.any? { _1[:ci_config].nil? }
  end

  def test_format_duration
    cli = new_cli
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

    new_cli

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

    new_cli

    assert_equal "id", Aws.config[:credentials].access_key_id
    assert_equal "secret", Aws.config[:credentials].secret_access_key
    assert_nil Aws.config[:region]

    refute_includes ENV, "AWS_ACCESS_KEY_ID"
    refute_includes ENV, "AWS_SECRET_ACCESS_KEY"
    refute_includes ENV, "AWS_REGION"
  end

  private

  def new_cli(**params)
    Runners::CLI.new(
      argv: ["--analyzer=rubocop", "test-guid"],
      stdout: stdout,
      stderr: stderr,
      options_json: options_json,
      working_dir: @tmpdir,
      **params,
    )
  end

  def stdout
    @stdout ||= StringIO.new
  end

  def stderr
    @stderr ||= StringIO.new
  end

  def options_json(options = { source: new_source })
    JSON.dump(options)
  end

  def traces
    @traces ||= JSONSEQ::Reader.new(
      io: StringIO.new(stdout.string),
      decoder: ->(string) { JSON.parse(string, symbolize_names: true) },
    ).each_object.to_a
  end
end
