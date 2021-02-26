require "test_helper"

class ConfigGeneratorTest < Minitest::Test
  include TestHelper

  def test_generate
    assert_yaml "test_generate.yml",
                tools: [],
                comment_out_lines: [8..12, 15..19]
  end

  def test_generate_with_tools
    # NOTE: Use all the tools to check schema for the whole example.
    analyzers = Runners::Analyzers.new
    tools = Runners::Processor.children.keys
      .reject { |id| analyzers.deprecated?(id) || analyzers.metrics?(id) }

    assert_yaml "test_generate_with_tools.yml",
                tools: tools,
                comment_out_lines: [10..404, 407..411, 414..418]
  end

  private

  def assert_yaml(expected_filename, tools:, comment_out_lines:)
    actual = Runners::ConfigGenerator.new.generate(tools: tools)

    assert_equal data(expected_filename).read, actual

    # Comment out
    content = actual.lines.map.with_index(1) do |line, line_num|
      if comment_out_lines.any? { |lines| lines.include?(line_num) }
        line.delete_prefix("# ")
      else
        line
      end
    end.join

    config = Runners::Config.new(path: "foo.yml", raw_content: content)
    assert_equal ["*.pdf", "*.mp4", "*.min.*", "images/**"], config.content[:ignore], content
    assert_equal ["master", "development", "/^release-.*$/"], config.content[:branches][:exclude], content

    unless tools.empty?
      linters = config.content[:linter]
      tools.each { |tool| assert_instance_of Hash, linters[tool] }
      # TODO: assert_equal linters.size, tools.size
    end
  end
end
