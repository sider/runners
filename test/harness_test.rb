require_relative "test_helper"

class HarnessTest < Minitest::Test
  include TestHelper

  Harness = Runners::Harness
  Processor = Runners::Processor
  Results = Runners::Results
  Issue = Runners::Issue
  Location = Runners::Location
  Analyzer = Runners::Analyzer
  Workspace = Runners::Workspace
  Options = Runners::Options

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def with_options(head: data("foo.tgz"))
    with_runners_options_env(source: { head: head }) do
      yield Runners::Options.new(StringIO.new, StringIO.new)
    end
  end

  class TestProcessor < Processor
    def analyzer_id
      "test"
    end

    def analyzer_name
      "Test"
    end

    def analyzer_version
      "0.1.3"
    end

    def analyze(changes)
      Results::Success.new(guid: guid, analyzer: analyzer)
    end
  end

  class BrokenProcessor < Processor
    def initialize(*args)
      raise StandardError, "broken!"
    end
  end

  def test_run
    mktmpdir do |working_dir|
      with_options do |options|
        mock.proxy(Workspace).prepare(options: options, working_dir: working_dir, trace_writer: trace_writer)
        harness = Harness.new(guid: SecureRandom.uuid, processor_class: TestProcessor,
                              options: options, working_dir: working_dir, trace_writer: trace_writer)

        result = harness.run
        assert_instance_of Results::Success, result
      end
    end
  end

  def test_run_when_using_broken_processor
    mktmpdir do |working_dir|
      with_options do |options|
        harness = Harness.new(guid: SecureRandom.uuid, processor_class: BrokenProcessor,
                              options: options, working_dir: working_dir, trace_writer: trace_writer)

        result = harness.run
        assert_instance_of Results::Error, result
        assert_equal(
          ["broken! (StandardError)"],
          trace_writer.writer.filter { |e| e[:trace] == :error }.map { |e| e[:message] },
        )
      end
    end
  end

  def test_run_filters_issues
    processor = Class.new(Processor) do
      def analyzer_id
        'test'
      end

      def analyzer_name
        "Test"
      end

      def analyzer_version
        "0.1.3"
      end

      def analyze(changes)
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          result.add_issue Issue.new(
            path: Pathname("test/cli/test_test.rb"),
            location: Location.new(start_line: 0),
            id: "id1",
            message: "...",
          )
          result.add_issue Issue.new(
            path: Pathname("no_such_file"),
            location: Location.new(start_line: 0),
            id: "id2",
            message: "...",
          )
          result.add_issue Issue.new(
            path: Pathname("taggeing_test.rb"),
            location: Location.new(start_line: 0),
            id: "id3",
            message: "...",
          )
        end
      end
    end

    mktmpdir do |working_dir|
      with_options do |options|
        harness = Harness.new(guid: SecureRandom.uuid, processor_class: processor,
                              options: options, working_dir: working_dir, trace_writer: trace_writer)

        result = harness.run

        assert_instance_of Results::Success, result
        assert_equal [Issue.new(
          path: Pathname("test/cli/test_test.rb"),
          location: Location.new(start_line: 0),
          id: "id1",
          message: "...",
        )], result.issues
      end
    end
  end

  def test_run_when_root_dir_not_found
    mktmpdir do |working_dir|
      (working_dir / "sider.yml").write(YAML.dump({ "linter" => { "test" => { "root_dir" => "foo" } } }))
      with_options do |options|
        harness = Harness.new(guid: SecureRandom.uuid, processor_class: TestProcessor,
                              options: options, working_dir: working_dir, trace_writer: trace_writer)

        assert_instance_of Results::Failure, harness.run
      end
    end
  end

  def test_run_when_config_is_broken
    mktmpdir do |working_dir|
      (working_dir / "sider.yml").write('1: 1:')
      with_options do |options|
        harness = Harness.new(guid: SecureRandom.uuid, processor_class: TestProcessor,
                              options: options, working_dir: working_dir, trace_writer: trace_writer)

        result = harness.run
        assert_instance_of Results::Failure, result
        assert_equal "Your `sider.yml` is broken at line 1 and column 5. Please fix and retry.", result.message
      end
    end
  end

  def test_ensure_result_returns_error_result_if_raised
    mktmpdir do |working_dir|
      with_options do |options|
        harness = Harness.new(guid: SecureRandom.uuid, processor_class: TestProcessor,
                              options: options, working_dir: working_dir, trace_writer: trace_writer)

        result = harness.send(:ensure_result) do
          JSON.parse("something wrong")
        end
        assert_instance_of Results::Error, result
        assert_instance_of JSON::ParserError, result.exception
        assert_equal(
          [{ trace: :error, message: "783: unexpected token at 'something wrong' (JSON::ParserError)" }],
          trace_writer.writer.map { |entry| entry.slice(:trace, :message) },
        )
      end
    end
  end

  def test_ensure_result_checks_validity_of_issues
    mktmpdir do |working_dir|
      with_options do |options|
        harness = Harness.new(guid: SecureRandom.uuid, processor_class: TestProcessor,
                              options: options, working_dir: working_dir, trace_writer: trace_writer)

        result = harness.send(:ensure_result) do
          Results::Success.new(guid: nil, analyzer: Analyzer.new(name: "foo", version: "1.0.3"))
        end
        assert_instance_of Results::Error, result
        assert_instance_of Harness::InvalidResult, result.exception
        assert_equal "Invalid result: #{result.exception.result.inspect}", result.exception.message
        assert_equal [], trace_writer.writer
      end
    end
  end

  def test_setup_analyze
    processor = Class.new(Processor) do
      def analyzer_id
        'test'
      end

      def analyzer_name
        'Test'
      end

      def analyzer_version
        '0.1.3'
      end

      def setup
        (current_dir + "touch").write("#setup should be called before #analyze")
        yield
      end

      def analyze(changes)
        (current_dir + "touch").file? or raise
        Results::Success.new(guid: guid, analyzer: analyzer)
      end
    end

    mktmpdir do |working_dir|
      with_options do |options|
        harness = Harness.new(guid: SecureRandom.uuid, processor_class: processor,
                              options: options, working_dir: working_dir, trace_writer: trace_writer)
        result = harness.run
        assert_instance_of Results::Success, result
        refute trace_writer.writer.find { |record| record[:message]&.match(/\ADeleting specified files via the `ignore` option/) }
      end
    end
  end

  def test_exclude_special_dirs
    processor_class = Class.new(TestProcessor) do
      def analyze(_)
        if (working_dir / ".git").exist?
          raise
        else
          super
        end
      end
    end

    mktmpdir do |working_dir|
      with_options do |options|
        (working_dir / ".git").mkpath
        (working_dir / ".git" / "config").write("...")

        harness = Harness.new(guid: SecureRandom.uuid, processor_class: processor_class,
                              options: options, working_dir: working_dir, trace_writer: trace_writer)
        result = harness.run

        assert_instance_of Results::Success, result
        assert_path_exists working_dir / ".git" / "config"
      end
    end
  end
end
