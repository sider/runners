require "test_helper"

class ShellTest < Minitest::Test
  include TestHelper

  Shell = Runners::Shell

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def assert_trace_writer(expected)
    actual = trace_writer.writer.map do |entry|
      entry.reject { |key,| key == :recorded_at }
    end
    assert_equal expected, actual
  end

  def test_chdir
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})
      assert_equal path, shell.current_dir

      (path / "foo").tap(&:mkpath)
      ret = shell.chdir(path / "foo") do |dir|
        assert_equal(path / "foo", dir)
        assert_equal(path / "foo", shell.current_dir)

        # Nested
        (dir / "bar").tap(&:mkpath)
        shell.chdir(dir / "bar") do |dir2|
          assert_equal(dir / "bar", dir2)
          assert_equal(dir / "bar", shell.current_dir)
        end

        assert_equal(path / "foo", shell.current_dir)
        "Hi."
      end
      assert_equal "Hi.", ret

      assert_equal path, shell.current_dir
    end
  end

  def test_capture3_trace
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})

      stdout, stderr, status = shell.capture3_trace("echo", "Hello")

      assert_equal "Hello\n", stdout
      assert_equal "", stderr
      assert status.success?
      assert_trace_writer [
        { trace: :command_line, command_line: ["echo", "Hello"] },
        { trace: :stdout, string: "Hello", truncated: false },
        { trace: :status, status: 0 },
      ]
    end
  end

  def test_capture3_trace_without_tracing_stdout
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})

      stdout, stderr, status = shell.capture3_trace("echo", "Hello", trace_stdout: false)

      assert_equal "Hello\n", stdout
      assert_equal "", stderr
      assert status.success?
      assert_trace_writer [
        { trace: :command_line, command_line: ["echo", "Hello"] },
        { trace: :status, status: 0 },
      ]
    end
  end

  def test_capture3_trace_without_tracing_stderr
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})

      stdout, stderr, status = shell.capture3_trace("echo Hello | tee /dev/stderr", trace_stderr: false)

      assert_equal "Hello\n", stdout
      assert_equal "Hello\n", stderr
      assert status.success?
      assert_trace_writer [
        { trace: :command_line, command_line: ["echo Hello | tee /dev/stderr"] },
        { trace: :stdout, string: "Hello", truncated: false },
        { trace: :status, status: 0 },
      ]
    end
  end

  def test_capture3_trace_raise_on_failure
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})

      error = assert_raises Shell::ExecError do
        shell.capture3_trace("echo Error | tee /dev/stderr && exit 1", raise_on_failure: true)
      end

      assert_equal "Command [echo Error | tee /dev/stderr && exit 1] exited with 1", error.message
      assert_equal :capture3, error.type
      assert_equal ["echo Error | tee /dev/stderr && exit 1"], error.args
      assert_equal "Error\n", error.stdout_str
      assert_equal "Error\n", error.stderr_str
      assert_equal 1, error.status.exitstatus
      assert_equal path, error.dir
      assert_trace_writer [
        { trace: :command_line, command_line: ["echo Error | tee /dev/stderr && exit 1"] },
        { trace: :stdout, string: "Error", truncated: false },
        { trace: :stderr, string: "Error", truncated: false },
        { trace: :status, status: 1 },
      ]

      bugsnag = error.bugsnag_meta_data.fetch(:details)
      assert_equal ["echo Error | tee /dev/stderr && exit 1"], bugsnag.fetch(:args)
      assert_equal "Error\n", bugsnag.fetch(:stdout)
      assert_equal "Error\n", bugsnag.fetch(:stderr)
      assert_match %r{#<Process::Status: pid \d+ exit 1>}, bugsnag.fetch(:status)
      assert_equal 1, bugsnag.fetch(:exitstatus)
      assert_nil bugsnag.fetch(:stopsig)
      assert_nil bugsnag.fetch(:termsig)
    end
  end

  def test_capture3_trace_with_custom_success
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})

      stdout, stderr, status = shell.capture3_trace(
        "echo Hello && exit 1",
        is_success: ->(status) { [0, 1].include? status.exitstatus }
      )

      assert_equal "Hello\n", stdout
      assert_equal "", stderr
      assert_equal 1, status.exitstatus
      assert_trace_writer [
        { trace: :command_line, command_line: ["echo Hello && exit 1"] },
        { trace: :stdout, string: "Hello", truncated: false },
        { trace: :status, status: 1 },
      ]
    end
  end

  def test_capture3_trace_with_stdin_data
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})

      stdout, = shell.capture3_trace("cat", stdin_data: "foo!")

      assert_equal "foo!", stdout
      assert_trace_writer [
                            { trace: :command_line, command_line: ["cat"] },
                            { trace: :stdout, string: "foo!", truncated: false },
                            { trace: :status, status: 0 },
                          ]
    end
  end

  def test_capture3_trace_with_chdir
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})
      (path / "1.txt").write("Number: 1")
      (path / "foo").mkdir
      (path / "foo" / "2.txt").write("Number: 2")

      stdout, _, status = shell.capture3_trace("cat", "1.txt")
      assert status.success?
      assert_equal "Number: 1", stdout

      _, _, status = shell.capture3_trace("cat", "2.txt")
      refute status.success?

      stdout, _, status = shell.capture3_trace("cat", "2.txt", chdir: path / "foo")
      assert status.success?
      assert_equal "Number: 2", stdout
    end
  end

  def test_capture3_trace_with_chdir_nil
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})
      (path / "1.txt").write("Number: 1")

      stdout, _, status = shell.capture3_trace("cat", "1.txt", chdir: nil)
      assert status.success?
      assert_equal "Number: 1", stdout
    end
  end

  def test_capture3_trace_with_merge_output
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})

      output_to_both = "echo 'stdout' ; echo 'stderr' >&2"
      stdout_and_stderr, stderr, status = shell.capture3_trace(output_to_both, merge_output: true)

      assert_equal "stdout\nstderr\n", stdout_and_stderr
      assert_equal "", stderr
      assert status.success?
      assert_equal [
        { trace: :command_line, command_line: ["echo 'stdout' ; echo 'stderr' >&2"] },
        { trace: :stdout, string: "stdout\n" + "stderr", truncated: false },
        { trace: :status, status: 0 },
      ], trace_writer.writer.each { |entry| entry.delete(:recorded_at) }
    end
  end

  def test_capture3_trace_with_merge_output_and_errored
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})

      error = assert_raises Shell::ExecError do
        shell.capture3_trace("echo 'Hello' ; exit 1", merge_output: true, raise_on_failure: true)
      end

      assert_equal :capture2e, error.type
      assert_equal ["echo 'Hello' ; exit 1"], error.args
      assert_equal "Hello\n", error.stdout_str
      assert_equal "", error.stderr_str
      assert_equal 1, error.status.exitstatus
      assert_equal path, error.dir
    end
  end

  def test_masking_senstives_in_exception
    mktmpdir do |path|
      shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})

      error = assert_raises Shell::ExecError do
        shell.capture3!("echo '[stdout] user:secret' ; echo '[stderr] user:secret' 1>&2 ; exit 1")
      end

      assert_equal "[stdout] [FILTERED]\n", error.stdout_str
      assert_equal "[stderr] [FILTERED]\n", error.stderr_str
    end
  end
end
