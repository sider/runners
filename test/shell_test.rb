require "test_helper"

class ShellTest < Minitest::Test
  include TestHelper

  Shell = Runners::Shell

  def trace_writer
    @trace_writer ||= Runners::TraceWriter.new(writer: [])
  end

  def assert_trace_writer(expected)
    actual = trace_writer.writer.map do |entry|
      entry.reject { |key,| key == :recorded_at }
    end
    assert_equal expected, actual
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

      assert_equal({
        details: {
          args: ["echo Error | tee /dev/stderr && exit 1"],
          stdout: "Error\n",
          stderr: "Error\n",
          status: 1,
        }
      }, error.bugsnag_meta_data)
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
end
