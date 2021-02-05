require "test_helper"

class ConfigGeneratorTest < Minitest::Test
  include TestHelper

  def setup
    @subject = Runners::ConfigGenerator.new
  end

  def test_generate
    assert_yaml data("#{__method__}.yml").read, @subject.generate
  end

  def test_generate_with_tools
    assert_yaml data("#{__method__}.yml").read, @subject.generate(tools: [:brakeman, :eslint])
  end

  private

  def assert_yaml(expected, actual)
    assert_equal expected, actual

    # Comment out
    yaml = actual.lines.map.with_index(1) do |line, line_num|
      if line_num <= 4 # Skip header
        line
      else
        line.delete_prefix("# ")
      end
    end.join
    Runners::Config.new(path: "foo.yml", raw_content: yaml).validate
  end
end
