require "test_helper"

class ConfigGeneratorTest < Minitest::Test
  include TestHelper

  def setup
    @subject = Runners::ConfigGenerator.new
  end

  def test_generate
    assert_yaml <<-YAML, @subject.generate
## This is a configuration file to customize code analysis by Sider.
##
## For more information, see the documentation:
## https://help.sider.review/getting-started/custom-configuration

## Customize each tools. For example:
# linter:

## Ignore specific files. For example:
# ignore:
#   - "*.pdf"
#   - "*.mp4"
#   - "*.min.*"
#   - "images/**"

## Exclude specific branches. For example:
# branches:
#   exclude:
#     - master
#     - development
#     - /^release-.*$/
    YAML
  end

  def test_generate_with_tools
    assert_yaml <<-YAML, @subject.generate(tools: [:eslint])
## This is a configuration file to customize code analysis by Sider.
##
## For more information, see the documentation:
## https://help.sider.review/getting-started/custom-configuration

## Customize each tools. For example:
# linter:
  ## ESLint configuration. See: https://help.sider.review/tools/javascript/eslint
  # eslint:
  #   root_dir: frontend/
  #   npm_install: false
  #   target:
  #     - src/
  #     - lib/
  #   ext: ".js,.jsx"
  #   config: config/.eslintrc.js
  #   ignore-path: config/.eslintignore
  #   ignore-pattern: vendor/**
  #   no-ignore: true
  #   global: require,exports:true
  #   quiet: true

## Ignore specific files. For example:
# ignore:
#   - "*.pdf"
#   - "*.mp4"
#   - "*.min.*"
#   - "images/**"

## Exclude specific branches. For example:
# branches:
#   exclude:
#     - master
#     - development
#     - /^release-.*$/
    YAML
  end

  private

  def assert_yaml(expected, actual)
    assert_equal expected, actual

    # Check YAML commented out
    YAML.parse actual.gsub(/^\s*# /, "")
  end
end
