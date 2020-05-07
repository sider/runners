require_relative "test_helper"
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

  def test_parsing_options
    with_runners_options_env(source: { head: 'http://example.com/head' }) do
      cli = CLI.new(argv: %w(--analyzer=rubocop test-guid), stdout: stdout, stderr: stderr)

      # Given parameters
      assert_equal "test-guid", cli.guid
      assert_equal 'rubocop', cli.analyzer
      assert_instance_of(Runners::Options, cli.options)
    end
  end

  def test_validate_options
    with_runners_options_env(source: { head: 'http://example.com/head' }) do
      assert_raises RuntimeError do
        # analyzer is missing
        CLI.new(argv: %w(test-guid), stdout: stdout, stderr: stderr)
      end

      assert_raises RuntimeError do
        # Invalid analyzer
        CLI.new(argv: %w(--analyzer=FOO test-guid), stdout: stdout, stderr: stderr)
      end.tap do |error|
        assert_equal "Not found processor class with 'FOO'", error.message
      end

      assert_raises RuntimeError do
        # GUID is not set
        CLI.new(argv: %w[--analyzer=rubocop], stdout: stdout, stderr: stderr)
      end.tap do |error|
        assert_equal "GUID is required", error.message
      end
    end
  end

  class TestProcessor < Runners::Processor
    def analyzer_id
      "rubocop"
    end

    def setup
      yield
    end

    def analyze(changes)
      trace_writer.command_line ["test", "command"]
      trace_writer.status Struct.new(:exitstatus).new(31)

      add_warning('hogehogewarn')

      Runners::Results::Success.new(guid: guid, analyzer: Runners::Analyzer.new(name: "test-analyzer", version: "3.14"))
    end
  end

  def test_run
    mktmpdir do |head_dir|
      with_runners_options_env(source: { head: head_dir }) do
        head_dir.join('sider.yml').write(<<~YAML)
          ignore: 'special/files'
        YAML
        cli = CLI.new(argv: ["--analyzer=rubocop", "test-guid"], stdout: stdout, stderr: stderr)
        cli.instance_variable_set(:@processor_class, TestProcessor)
        cli.run

        # It write JSON objects to stdout

        output = stdout.string
        reader = JSONSEQ::Reader.new(io: StringIO.new(output), decoder: -> (string) { JSON.parse(string, symbolize_names: true) })
        objects = reader.each_object.to_a

        assert objects.find { |hash| hash[:trace] == 'command_line' && hash[:command_line] == ["test", "command"] }
        assert objects.find { |hash| hash[:trace] == 'status' && hash[:status] == 31 }
        assert objects.find { |hash| hash[:trace] == 'warning' && hash[:message] == 'hogehogewarn' }
        assert objects.find { |hash| hash[:warnings] == [{ message: 'hogehogewarn', file: nil }] }
        assert objects.find { |hash| hash[:ci_config] == { linter: nil, ignore: "special/files", branches: nil } }
      end
    end
  end

  def test_run_when_sider_yml_is_broken
    mktmpdir do |head_dir|
      with_runners_options_env(source: { head: head_dir }) do
        head_dir.join('sider.yml').write("1: 1:")
        cli = CLI.new(argv: ["--analyzer=rubocop", "test-guid"], stdout: stdout, stderr: stderr)
        cli.instance_variable_set(:@processor_class, TestProcessor)
        cli.run

        # It write JSON objects to stdout

        output = stdout.string
        reader = JSONSEQ::Reader.new(io: StringIO.new(output), decoder: -> (string) { JSON.parse(string, symbolize_names: true) })
        objects = reader.each_object.to_a

        assert objects.find { |hash| hash.dig(:result, :type) == 'failure' }
        assert objects.find { |hash| hash[:warnings] == [] }
        assert objects.find { |hash| hash[:ci_config] == nil }
      end
    end
  end

  def test_run_when_download_error_happens
    mktmpdir do |head_dir|
      with_runners_options_env(source: { head: head_dir }) do
        cli = CLI.new(argv: ["--analyzer=rubocop", "test-guid"], stdout: stdout, stderr: stderr)
        cli.instance_variable_set(:@processor_class, TestProcessor)
        any_instance_of(Runners::Workspace) do |instance|
          mock(instance).open.with_any_args { raise Runners::Workspace::DownloadError }
        end
        cli.run

        output = stdout.string
        reader = JSONSEQ::Reader.new(io: StringIO.new(output), decoder: -> (string) { JSON.parse(string, symbolize_names: true) })
        objects = reader.each_object.to_a

        assert objects.find { |hash| hash.dig(:result, :type) == 'error' }
        assert objects.find { |hash| hash.dig(:result, :class) == 'Runners::Workspace::DownloadError' }
      end
    end
  end

  def test_run_when_the_source_contains_userinfo
    mktmpdir do |head_dir|
      with_runners_options_env(source: { head: head_dir, git_http_url: 'https://github.com', owner: 'foo', repo: 'bar', git_http_userinfo: 'user:secret' }) do
        mock.proxy(TraceWriter).new(writer: anything, sensitive_strings: ['user:secret'])

        cli = CLI.new(argv: ["--analyzer=rubocop", "test-guid"], stdout: stdout, stderr: stderr)
        cli.instance_variable_set(:@processor_class, TestProcessor)
        cli.run
      end
    end
  end


  def test_processor_class
    with_runners_options_env(source: { head: 'http://example.com/head' }) do
      cli = CLI.new(argv: %w[--analyzer=rubocop test-guid], stdout: stdout, stderr: stderr)
      assert_equal Runners::Processor::RuboCop, cli.processor_class

      cli = CLI.new(argv: %w[--analyzer=scss_lint test-guid], stdout: stdout, stderr: stderr)
      assert_equal Runners::Processor::ScssLint, cli.processor_class

      error = assert_raises { CLI.new(argv: %w[--analyzer=foo test-guid], stdout: stdout, stderr: stderr) }
      assert_equal "Not found processor class with 'foo'", error.message
    end
  end

  def test_format_duration
    with_runners_options_env(source: { head: 'http://example.com/head' }) do
      cli = CLI.new(argv: %w[--analyzer=rubocop test-guid], stdout: stdout, stderr: stderr)
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
end
