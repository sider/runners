require "test_helper"

class WarningsTest < Minitest::Test
  include TestHelper

  def test_add
    warnings.add "foo"
    warnings.add "foo"
    warnings.add " bar "
    warnings.add " bar "
    warnings.add "\n baz \n", file: "a.yml"
    warnings.add "\n baz \n", file: "a.yml"

    assert_warnings [{ message: "foo", file: nil },
                     { message: "bar", file: nil },
                     { message: "baz", file: "a.yml" }]
  end

  def test_add_with_truncated_message
    warnings.add "0123456789_", limit: 10

    assert_warnings [{ message: "0123456789\n...(truncated)", file: nil }]
  end

  def test_add_with_trace_writer
    trace_writer = new_trace_writer
    warnings = Runners::Warnings.new(trace_writer: trace_writer)
    warnings.add "foo"
    warnings.add " bar "
    warnings.add "\n baz \n", file: "a.yml"

    assert_equal [{ trace: :warning, message: "foo", file: nil },
                  { trace: :warning, message: "bar", file: nil },
                  { trace: :warning, message: "baz", file: "a.yml" }],
                 trace_writer.writer.map { |e| e.slice(:trace, :message, :file) }
  end

  def test_add_warning_if_deprecated_version
    warnings.add_warning_if_deprecated_version("Foo", current: "1.0.0", minimum: "0.9.9")
    warnings.add_warning_if_deprecated_version("Foo", current: "1.0.0", minimum: "1.0.0")
    warnings.add_warning_if_deprecated_version("Foo", current: "1.0.0", minimum: "1.0.1")
    warnings.add_warning_if_deprecated_version("Foo", current: "1.0.0", minimum: "1.0.1", deadline: Time.new(2020, 1, 9))

    assert_warnings [{ message: "Foo 1.0.0 is deprecated and will be dropped soon. Please update to 1.0.1 or higher.", file: nil },
                     { message: "Foo 1.0.0 is deprecated and will be dropped on January 9, 2020. Please update to 1.0.1 or higher.", file: nil },]
  end

  def test_add_warning_for_deprecated_linter
    warnings.add_warning_for_deprecated_linter(old: "Foo", new: "Bar")
    warnings.add_warning_for_deprecated_linter(old: "Foo", new: "Bar", links: ["https://foo", "https://bar"], deadline: Time.new(2020, 12, 31))

    assert_warnings [{ message: "The support for Foo is deprecated and will be removed soon. Please migrate to Bar.", file: nil },
                     { message: "The support for Foo is deprecated and will be removed on December 31, 2020. Please migrate to Bar. See below:\n- https://foo\n- https://bar", file: nil }]
  end

  private

  def warnings
    @warnings ||= Runners::Warnings.new
  end

  def assert_warnings(expected)
    assert_equal expected, warnings.as_json
  end
end
