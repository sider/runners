require "test_helper"

class ConfigGeneratorTest < Minitest::Test
  include TestHelper

  def test_generate
    assert_yaml "test_generate.yml", []
  end

  def test_generate_with_tools
    assert_yaml "test_generate_with_tools.yml", %i[brakeman checkstyle clang_tidy code_sniffer coffeelint cppcheck eslint]
  end

  private

  def assert_yaml(expected_filename, actual_tools)
    actual = Runners::ConfigGenerator.new.generate(tools: actual_tools)

    assert_equal data(expected_filename).read, actual

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

    unless actual_tools.empty?
      linters = config.content[:linter]
      actual_tools.each { |tool| assert_instance_of Hash, linters[tool] }
      # TODO: assert_equal linters.size, actual_tools.size
    end
  end
end
