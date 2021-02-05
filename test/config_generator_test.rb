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

    # Check YAML commented out
    YAML.parse actual.gsub(/^\s*# /, "")
  end
end
