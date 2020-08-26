require "test_helper"

class TraceWriterTest < Minitest::Test
  include TestHelper

  TraceWriter = Runners::TraceWriter

  def writer
    @writer ||= TraceWriter.new(writer: [], filter: sensitive_filter)
  end

  def now
    Time.utc(2017, 8, 1, 22, 34, 51.200)
  end

  def test_each_slice
    slices = []
    writer.instance_eval do
      each_slice("1234567890", size: 3) do |text|
        slices << text
      end
    end

    assert_equal ["123", "456", "789", "0"], slices
  end

  def test_stdout
    writer.stdout("hogehoge hugahuga", max_length: 10, recorded_at: now)

    assert_equal [{ trace: :stdout, string: "hogehoge h", recorded_at: "2017-08-01T22:34:51.200Z", truncated: true },
                  { trace: :stdout, string: "ugahuga", recorded_at: "2017-08-01T22:34:51.200Z", truncated: false }], writer.writer
  end

  def test_stderr
    writer.stderr("hogehoge hugahuga", max_length: 10, recorded_at: now)

    assert_equal [{ trace: :stderr, string: "hogehoge h", recorded_at: "2017-08-01T22:34:51.200Z", truncated: true },
                  { trace: :stderr, string: "ugahuga", recorded_at: "2017-08-01T22:34:51.200Z", truncated: false }], writer.writer
  end

  def test_message_with_block
    return_values = [
      Time.utc(2001, 1, 1, 0, 0, 0),
      Time.utc(2001, 1, 1, 0, 1, 0),
    ]
    writer.stub :now, ->() { return_values.shift } do
      writer.message("Hello", recorded_at: now) { "noop" }

      assert_equal [{ trace: :message, message: "Hello", recorded_at: "2017-08-01T22:34:51.200Z", truncated: false, duration_in_ms: 0 },
                    { trace: :message, message: "-> 60.0s", recorded_at: "2017-08-01T22:35:51.200Z", truncated: false, duration_in_ms: 60000 }], writer.writer
    end
  end

  def test_message_with_long_content
    long_text = 'a' * 10
    writer.message(long_text * 4, max_length: 10, recorded_at: now)
    assert_equal [{ trace: :message, message: long_text, recorded_at: "2017-08-01T22:34:51.200Z", truncated: true },
                  { trace: :message, message: long_text, recorded_at: "2017-08-01T22:34:51.200Z", truncated: true },
                  { trace: :message, message: long_text, recorded_at: "2017-08-01T22:34:51.200Z", truncated: true },
                  { trace: :message, message: long_text, recorded_at: "2017-08-01T22:34:51.200Z", truncated: true }], writer.writer
  end

  def test_message_with_limit
    writer.message("abcdef", limit: 3, recorded_at: now)
    assert_equal [{ trace: :message, message: "abc...(truncated)", recorded_at: "2017-08-01T22:34:51.200Z", truncated: true }], writer.writer
  end

  def test_message_with_omission
    writer.message("abcdef", limit: 3, omission: "...", recorded_at: now)
    assert_equal [{ trace: :message, message: "abc...", recorded_at: "2017-08-01T22:34:51.200Z", truncated: true }], writer.writer
  end

  def test_warning
    writer.warning('hogehoge warn', recorded_at: now)
    writer.warning('hogehoge warn2', file: 'path/to/file.rb', recorded_at: now)

    assert_equal [{ trace: :warning, message: "hogehoge warn", file: nil, recorded_at: "2017-08-01T22:34:51.200Z" },
                  { trace: :warning, message: "hogehoge warn2", file: 'path/to/file.rb', recorded_at: "2017-08-01T22:34:51.200Z" }], writer.writer
  end

  def test_ci_config
    content = {'linter' => {'rubocop' => {'config' => 'myrubocop.yml'}}}
    writer.ci_config(content, raw_content: "foo", file: "foo.yml", recorded_at: now)
    assert_equal [{ trace: :ci_config, content: content, raw_content: "foo", file: "foo.yml", recorded_at: "2017-08-01T22:34:51.200Z" }], writer.writer
  end

  def test_error
    writer.error('hoge error', recorded_at: now)
    assert_equal [{ trace: :error, message: 'hoge error', recorded_at: "2017-08-01T22:34:51.200Z", truncated: false }], writer.writer
  end

  def test_masked_string
    writer.command_line(%w[cat https://user:secret@github.com], recorded_at: now)
    writer.stdout("user:secret in stdout", recorded_at: now)
    writer.stderr("user:secret in stderr", recorded_at: now)
    writer.message("Your 'user:secret' should not be exposed", recorded_at: now)
    writer.header("'user:secret' in header", recorded_at: now)
    writer.error("'user:secret' in error", recorded_at: now)
    writer.warning("'user:secret' in warning", recorded_at: now)
    expected = [
      { trace: :command_line, command_line: %w[cat https://[FILTERED]@github.com], recorded_at: "2017-08-01T22:34:51.200Z" },
      { trace: :stdout, string: "[FILTERED] in stdout", recorded_at: "2017-08-01T22:34:51.200Z", truncated: false },
      { trace: :stderr, string: "[FILTERED] in stderr", recorded_at: "2017-08-01T22:34:51.200Z", truncated: false },
      { trace: :message, message: "Your '[FILTERED]' should not be exposed", recorded_at: "2017-08-01T22:34:51.200Z", truncated: false },
      { trace: :header, message: "'[FILTERED]' in header", recorded_at: "2017-08-01T22:34:51.200Z" },
      { trace: :error, message: "'[FILTERED]' in error", recorded_at: "2017-08-01T22:34:51.200Z", truncated: false },
      { trace: :warning, message: "'[FILTERED]' in warning", file: nil, recorded_at: "2017-08-01T22:34:51.200Z" },
    ]
    assert_equal expected, writer.writer
  end
end
