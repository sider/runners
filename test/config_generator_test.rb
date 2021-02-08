require "test_helper"

class ConfigGeneratorTest < Minitest::Test
  include TestHelper

  def setup
    @subject = Runners::ConfigGenerator.new
  end

  def test_generate
    assert_yaml data("test_generate.yml").read,
                @subject.generate
  end

  def test_generate_with_tools
    assert_yaml data("test_generate_with_tools.yml").read,
                @subject.generate(tools: [:brakeman, :checkstyle, :eslint])
  end

  private

  def assert_yaml(expected, actual)
    assert_equal expected, actual

    # Comment out
    content = actual.lines.map.with_index(1) do |line, line_num|
      if line_num <= 4 # Skip header
        line
      else
        line.delete_prefix("# ")
      end
    end.join

    config = Runners::Config.new(path: "foo.yml", raw_content: content)
    assert_equal ["*.pdf", "*.mp4", "*.min.*", "images/**"], config.content[:ignore]
    assert_equal ["master", "development", "/^release-.*$/"], config.content[:branches][:exclude]

    linter = config.content[:linter]
    if linter
      refute_nil linter[:brakeman]
      refute_nil linter[:checkstyle]
      refute_nil linter[:eslint]
    end
  end
end
