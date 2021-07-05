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
    not_implemented_classes = [
      Runners::Processor::MetricsCodeClone,
      Runners::Processor::MetricsComplexity,
      Runners::Processor::MetricsFileInfo,
      Runners::Processor::ScssLint,
    ]
    tools = Runners::Processor.children.filter_map do |id, klass|
      next unless klass.name.start_with?("Runners::Processor::") # exclude test processor classes
      next if not_implemented_classes.include?(klass)
      id
    end

    end_line = 416
    assert_yaml "test_generate_with_tools.yml",
                tools: tools,
                comment_out_lines: [9..end_line, (end_line + 3)..(end_line + 7), (end_line + 10)..(end_line + 14)],
                assert_config: ->(config) {
                  assert_equal [:brakeman, :checkstyle, :clang_tidy, :code_sniffer, :coffeelint, :cppcheck, :cpplint, :detekt,
                                :eslint, :flake8, :fxcop, :golangci_lint, :goodcheck, :hadolint, :haml_lint, :javasee, :jshint,
                                :ktlint, :languagetool, :misspell, :phinder, :phpmd, :pmd_cpd, :pmd_java, :pylint, :querly,
                                :rails_best_practices, :reek, :remark_lint, :rubocop, :scss_lint, :shellcheck, :slim_lint,
                                :stylelint, :swiftlint, :tyscan],
                               config.content[:linter].keys.sort, config.inspect
                }
  end

  private

  def assert_yaml(expected_filename, tools:, comment_out_lines:, assert_config: ->(config) {  })
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

    assert_config.call(config)
  end
end
