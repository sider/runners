require "test_helper"

class HarnessTest < Minitest::Test
  include TestHelper

  Harness = Runners::Harness
  Processor = Runners::Processor
  Results = Runners::Results
  Issue = Runners::Issue
  Location = Runners::Location
  Analyzer = Runners::Analyzer

  private

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def with_harness(processor_class: TestProcessor, head: "330716dcd50a7a2c7d8ff79d74035c05453528b4")
    mktmpdir do |working_dir|
      options_json = JSON.dump(source: new_source(head: head))
      yield Harness.new(
        guid: "test-guid",
        processor_class: processor_class,
        options: Runners::Options.new(options_json, StringIO.new, StringIO.new),
        working_dir: working_dir,
        trace_writer: trace_writer,
      )
    end
  end

  class TestProcessor < Processor
    def analyzer_id; :test; end
    def analyzer_name; "Test"; end
    def default_analyzer_version; "0.1.3"; end

    def analyze(changes)
      Results::Success.new(guid: guid, analyzer: analyzer)
    end
  end

  public

  def test_run
    with_harness do |harness|
      assert_instance_of Results::Success, harness.run
    end
  end

  def test_run_when_using_broken_processor
    processor_class = Class.new(Processor) do
      def initialize(*args)
        raise StandardError, "broken!"
      end
    end

    with_harness(processor_class: processor_class) do |harness|
      assert_instance_of Results::Error, harness.run
      assert_equal(
        ["broken! (StandardError)"],
        trace_writer.writer.filter_map { |e| e[:message] if e[:trace] == :error },
      )
    end
  end

  def test_run_filters_issues
    klass = Class.new(TestProcessor) do
      def analyze(changes)
        issues = [
          Issue.new(
            path: Pathname("test.rb"),
            location: Location.new(start_line: 1),
            id: "id1",
            message: "id1 message",
          ),
          Issue.new(
            path: Pathname("no_such_file"),
            location: Location.new(start_line: 1),
            id: "id2",
            message: "id2 message",
          ),
          Issue.new(
            path: Pathname("taggeing_test.rb"),
            location: Location.new(start_line: 1),
            id: "id3",
            message: "id3 message",
          ),
        ]
        Results::Success.new(guid: guid, analyzer: analyzer, issues: issues)
      end
    end

    # https://github.com/sider/runners_test/pull/10
    with_harness processor_class: klass, head: "0f6d00e" do |harness|
      result = harness.run
      assert_instance_of Results::Success, result
      assert_equal [
        Issue.new(
          path: Pathname("test.rb"),
          location: Location.new(start_line: 1),
          id: "id1",
          message: "id1 message",
        ),
      ], result.issues
    end
  end

  def test_run_when_root_dir_not_found
    klass = Class.new(TestProcessor) do
      def analyzer_id; :eslint; end
    end

    # https://github.com/sider/runners_test/pull/8
    with_harness processor_class: klass, head: "7151469" do |harness|
      result = harness.run
      assert_instance_of Results::Failure, result
      assert_match "`foo` directory is not found!", result.message
    end
  end

  def test_run_when_config_is_broken
    # https://github.com/sider/runners_test/pull/9
    with_harness head: "7b15466" do |harness|
      result = harness.run
      assert_instance_of Results::Failure, result
      assert_equal "`sider.yml` is broken at line 1 and column 5 (mapping values are not allowed in this context)", result.message
    end
  end

  def test_ensure_result_returns_error_result_if_raised
    with_harness do |harness|
      result = harness.send(:ensure_result) { JSON.parse("something wrong") }

      assert_instance_of Results::Error, result
      assert_instance_of JSON::ParserError, result.exception
      assert_equal(
        [{ trace: :error, message: "809: unexpected token at 'something wrong' (JSON::ParserError)" }],
        trace_writer.writer.map { |entry| entry.slice(:trace, :message) },
      )
    end
  end

  def test_ensure_result_checks_validity_of_issues
    with_harness do |harness|
      result = harness.send(:ensure_result) do
        Results::Success.new(guid: nil, analyzer: Analyzer.new(name: "foo", version: "1.0.3"))
      end

      assert_instance_of Results::Error, result
      assert_instance_of Harness::InvalidResult, result.exception
      assert_equal "Invalid result: #{result.exception.result.inspect}", result.exception.message
      assert_equal [], trace_writer.writer
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

    with_harness(processor_class: processor_class) do |harness|
      result = harness.run

      assert_instance_of Results::Success, result
      assert_path_exists harness.working_dir / ".git" / "config"
    end
  end

  def test_not_exclude_special_dirs
    processor_class = Class.new(TestProcessor) do
      def use_git_metadata_dir?
        true
      end

      def analyze(_)
        if (working_dir / ".git").exist?
          super
        else
          raise
        end
      end
    end

    with_harness(processor_class: processor_class) do |harness|
      result = harness.run

      assert_instance_of Results::Success, result
      assert_path_exists harness.working_dir / ".git" / "config"
    end
  end

  def test_build_shell
    with_harness do |harness|
      working_dir = harness.working_dir
      git_ssh_path = working_dir / "id_rsa"

      mock_status = Minitest::Mock.new
      mock_status.expect :success?, false
      mock_status.expect :exited?, true
      mock_status.expect :exitstatus, 3

      mock_capture3 = Minitest::Mock.new
      mock_capture3.expect :call, ["", "", mock_status], [
        { "RUBYOPT" => nil, "GIT_SSH_COMMAND" => "ssh -F '#{git_ssh_path}'" },
        "ls",
        chdir: working_dir, stdin_data: nil
      ]

      Open3.stub :capture3, mock_capture3 do
        harness.send(:build_shell, git_ssh_path).capture3_trace("ls")

        assert_mock mock_status
        assert_mock mock_capture3
      end
    end
  end
end
