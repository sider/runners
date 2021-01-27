require "test_helper"

class ConfigTest < Minitest::Test
  include TestHelper

  FILE_NAME = Runners::Config::FILE_NAME
  FILE_NAME_OLD = Runners::Config::FILE_NAME_OLD

  def test_file_priority
    mktmpdir do |dir|
      (dir / FILE_NAME).write("")
      (dir / FILE_NAME_OLD).write("")
      assert_equal FILE_NAME, Runners::Config.load_from_dir(dir).path_name
    end
  end

  def test_content_without_sider_yml
    assert_equal({}, Runners::Config.new(path: nil, raw_content: nil).content)
  end

  def test_content_with_empty_sider_yml
    file = Pathname(FILE_NAME)
    assert_equal({}, Runners::Config.new(path: file, raw_content: "---").content)
    assert_equal({}, Runners::Config.new(path: file, raw_content: "---").content)
  end

  def test_content_with_linter_section
    yaml = <<~YAML
      ---
      linter:
        eslint:
          config: abc
          options:
            npm_install: true
    YAML
    assert_equal(
      { linter: {
        golint: nil, go_vet: nil, gometalinter: nil,
        brakeman: nil,
        checkstyle: nil,
        clang_tidy: nil,
        code_sniffer: nil,
        coffeelint: nil,
        cppcheck: nil,
        cpplint: nil,
        detekt: nil,
        eslint: {
          root_dir: nil,
          npm_install: nil,
          target: nil,
          dir: nil,
          ext: nil,
          config: "abc",
          "ignore-path": nil,
          "ignore-pattern": nil,
          "no-ignore": nil,
          global: nil,
          quiet: nil,
          options: { npm_install: true,
                     dir: nil,
                     ext: nil,
                     config: nil,
                     "ignore-path": nil,
                     "no-ignore": nil,
                     "ignore-pattern": nil,
                     global: nil,
                     quiet: nil,
          },
        },
        flake8: nil,
        fxcop: nil,
        golangci_lint: nil,
        goodcheck: nil,
        hadolint: nil,
        rubocop: nil,
        haml_lint: nil,
        javasee: nil,
        jshint: nil,
        ktlint: nil,
        languagetool: nil,
        metrics_complexity: nil,
        misspell: nil,
        phinder: nil,
        phpmd: nil,
        pmd_cpd: nil,
        pmd_java: nil,
        pylint: nil,
        querly: nil,
        rails_best_practices: nil,
        reek: nil,
        remark_lint: nil,
        scss_lint: nil,
        shellcheck: nil,
        stylelint: nil,
        swiftlint: nil,
        tslint: nil,
        tyscan: nil },
        ignore: nil,
        branches: nil,
      },
      Runners::Config.new(path: Pathname(FILE_NAME), raw_content: yaml).content,
    )
  end

  def test_content_with_unknown_linter
    yaml = <<~YAML
      ---
      linter:
        unknown_linter:
          config: abc
    YAML
    exn = assert_raises Runners::Config::InvalidConfiguration do
      Runners::Config.new(path: Pathname(FILE_NAME), raw_content: yaml).content
    end
    assert_equal "`linter.unknown_linter` in `sider.yml` is unsupported", exn.message
    assert_equal "sider.yml", exn.path_name
    assert_equal yaml, exn.raw_content
    assert_equal "$.linter.unknown_linter", exn.attribute
  end

  def test_content_with_invalid_type_of_linter
    yaml = <<~YAML
      ---
      linter: []
    YAML
    exn = assert_raises Runners::Config::InvalidConfiguration do
      Runners::Config.new(path: Pathname(FILE_NAME), raw_content: yaml).content
    end
    assert_equal "`linter` value in `sider.yml` is invalid", exn.message
    assert_equal "sider.yml", exn.path_name
    assert_equal yaml, exn.raw_content
    assert_equal "$.linter", exn.attribute
  end

  def test_content_with_ignore_section
    yaml = <<~YAML
      ---
      ignore:
        - ".pdf"
        - ".mp4"
        - "images/**"
    YAML
    assert_equal({ linter: nil, ignore: %w[.pdf .mp4 images/**], branches: nil },
                 Runners::Config.new(path: Pathname(FILE_NAME), raw_content: yaml).content)
  end

  def test_content_with_branches_section
    yaml = <<~YAML
      ---
      branches:
        exclude:
          - master
          - /^release-.*$/
    YAML
    assert_equal({ linter: nil, ignore: nil, branches: { exclude: %w[master /^release-.*$/] } },
                 Runners::Config.new(path: Pathname(FILE_NAME), raw_content: yaml).content)
  end

  def test_content_with_broken_yaml
    exn = assert_raises Runners::Config::BrokenYAML do
      Runners::Config.new(path: Pathname(FILE_NAME), raw_content: "\n  @\n").content
    end
    assert_equal "`sider.yml` is broken at line 2 and column 3 (found character that cannot start any token)", exn.message
    assert_equal "sider.yml", exn.path_name
    assert_equal "\n  @\n", exn.raw_content
    assert_equal 2, exn.line
    assert_equal 3, exn.column
    assert_equal "found character that cannot start any token", exn.problem
  end

  def test_path_name
    assert_equal FILE_NAME, Runners::Config.new(path: nil, raw_content: nil).path_name
    assert_equal FILE_NAME, Runners::Config.new(path: Pathname(FILE_NAME), raw_content: "").path_name
    assert_equal FILE_NAME_OLD, Runners::Config.new(path: Pathname(FILE_NAME_OLD), raw_content: "").path_name
  end

  def test_ignore_patterns
    assert_equal [], Runners::Config.new(path: nil, raw_content: nil).ignore_patterns

    file = Pathname(FILE_NAME)
    assert_equal %w[abc], Runners::Config.new(path: file, raw_content: "ignore: abc").ignore_patterns

    yaml = <<~YAML
      ignore:
        - "*.mp4"
        - docs/**/*.pdf
    YAML
    assert_equal %w[*.mp4 docs/**/*.pdf], Runners::Config.new(path: file, raw_content: yaml).ignore_patterns
  end

  def test_linter
    yaml = <<~YAML
      linter:
        eslint:
          ext: .js
    YAML
    assert_equal({
      ext: ".js",
      root_dir: nil,
      npm_install: nil,
      target: nil,
      dir: nil,
      config: nil,
      "ignore-path": nil,
      "ignore-pattern": nil,
      "no-ignore": nil,
      global: nil,
      quiet: nil,
      options: nil,
    }, Runners::Config.new(path: Pathname(FILE_NAME), raw_content: yaml).linter("eslint"))
  end

  def test_linter_default
    assert_equal({}, Runners::Config.new(path: Pathname(FILE_NAME), raw_content: "").linter("eslint"))
  end

  def test_linter?
    file = Pathname(FILE_NAME)
    yaml = <<~YAML
      linter:
        eslint: { root_dir: "src" }
    YAML
    config = Runners::Config.new(path: file, raw_content: yaml)
    assert config.linter?("eslint")
    refute config.linter?("foo")

    refute Runners::Config.new(path: file, raw_content: "").linter?("foo")
  end

  def test_removed_go_tools_do_not_break
    yaml = <<~YAML
      linter:
        golint:
          root_dir: src/
        go_vet:
          root_dir: lib/
        gometalinter:
          root_dir: module/
          import_path: foo
    YAML
    config = Runners::Config.new(path: Pathname(FILE_NAME), raw_content: yaml)
    assert_equal({ root_dir: "src/" }, config.linter("golint"))
    assert_equal({ root_dir: "lib/" }, config.linter("go_vet"))
    assert_equal({ root_dir: "module/", import_path: "foo" }, config.linter("gometalinter"))
  end

  def test_check_unsupported_linters
    yaml = <<~YAML
      linter:
        golint: {}
        go_vet: {}
    YAML
    config = Runners::Config.new(path: Pathname(FILE_NAME), raw_content: yaml)
    assert_equal <<~MSG, config.check_unsupported_linters(%w[golint go_vet gometalinter])
      The following linters in your `sider.yml` are no longer supported. Please remove them.
      - `linter.golint`
      - `linter.go_vet`
    MSG
  end

  def test_check_unsupported_linters_empty
    config = Runners::Config.new(path: Pathname(FILE_NAME), raw_content: "")
    assert_equal "", config.check_unsupported_linters(%w[foo bar])
  end

  def test_exclude_branch?
    yaml = <<~YAML
      branches:
        exclude:
          - foo
          - /^bar/
          - /baz/i
          - /abc
          - /^features\/.+/
    YAML
    config = Runners::Config.new(path: Pathname(FILE_NAME), raw_content: yaml)

    assert config.exclude_branch?("foo")
    refute config.exclude_branch?("foooo")
    assert config.exclude_branch?("bar")
    assert config.exclude_branch?("bar--")
    refute config.exclude_branch?("--bar--")
    assert config.exclude_branch?("baz")
    assert config.exclude_branch?("BAZ")
    assert config.exclude_branch?("/abc")
    refute config.exclude_branch?("abc")
    assert config.exclude_branch?("features/123")
    refute config.exclude_branch?("features/")
  end

  def test_valid
    assert Runners::Config.new(path: Pathname(FILE_NAME), raw_content: "").valid?
    refute Runners::Config.new(path: Pathname(FILE_NAME), raw_content: "`").valid?
  end

  def test_invalid
    assert Runners::Config.new(path: Pathname(FILE_NAME), raw_content: "`").invalid?
    refute Runners::Config.new(path: Pathname(FILE_NAME), raw_content: "").invalid?
  end

  def test_parse
    assert_nil Runners::Config.new(path: Pathname(FILE_NAME), raw_content: nil).parse
    assert_nil Runners::Config.new(path: Pathname(FILE_NAME), raw_content: "").parse
    assert_equal [1, "foo", true], Runners::Config.new(path: Pathname(FILE_NAME), raw_content: "[1, foo, true]").parse

    assert_raises Runners::Config::BrokenYAML do
      Runners::Config.new(path: Pathname(FILE_NAME), raw_content: "`").parse
    end
  end
end
