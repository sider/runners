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
    tools = Runners::Processor.children.filter_map do |id, klass|
      begin
        klass.config_example
        id
      rescue NotImplementedError
        nil
      end
    end

    end_line = 405
    assert_yaml "test_generate_with_tools.yml",
                tools: tools,
                comment_out_lines: [9..end_line, (end_line + 3)..(end_line + 7), (end_line + 10)..(end_line + 14)]
  end

  private

  def assert_yaml(expected_filename, tools:, comment_out_lines:)
    actual = Runners::ConfigGenerator.new.generate(tools: tools)

    assert_equal data(expected_filename).read, actual

    # Uncomment
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
      assert_equal linters.keys.sort, (tools + %i[scss_lint tslint]).sort
    end
  end
end
