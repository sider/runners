require "test_helper"

class ConfigTest < Minitest::Test
  include TestHelper

  CONFIG_FILE_NAME = Runners::Config::CONFIG_FILE_NAME
  OLD_CONFIG_FILE_NAME = Runners::Config::OLD_CONFIG_FILE_NAME

  def test_file_priority
    mktmpdir do |dir|
      (dir / CONFIG_FILE_NAME).write("")
      (dir / OLD_CONFIG_FILE_NAME).write("")
      assert_equal CONFIG_FILE_NAME, Runners::Config.load_from_dir(dir).path_name
    end
  end

  def test_content_without_sider_yml
    assert_equal({}, Runners::Config.new(nil).content)
  end

  def test_content_with_empty_sider_yml
    mktmpdir do |dir|
      file = dir / CONFIG_FILE_NAME

      file.write("---")
      assert_equal({}, Runners::Config.new(file).content)

      file.write("")
      assert_equal({}, Runners::Config.new(file).content)
    end
  end

  def test_content_with_linter_section
    mktmpdir do |dir|
      file = dir / CONFIG_FILE_NAME
      file.write <<~YAML
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
        Runners::Config.new(file).content,
      )
    end
  end

  def test_content_with_unknown_linter
    mktmpdir do |dir|
      yaml = <<~YAML
        ---
        linter:
          unknown_linter:
            config: abc
      YAML
      file = (dir / CONFIG_FILE_NAME).tap { _1.write(yaml) }
      exn = assert_raises Runners::Config::InvalidConfiguration do
        Runners::Config.new(file)
      end
      assert_equal "The attribute `linter.unknown_linter` in your `sider.yml` is unsupported. Please fix and retry.", exn.message
      assert_equal yaml, exn.raw_content
    end
  end

  def test_content_with_invalid_type_of_linter
    mktmpdir do |dir|
      yaml = <<~YAML
        ---
        linter: []
      YAML
      file = (dir / CONFIG_FILE_NAME).tap { _1.write(yaml) }
      exn = assert_raises Runners::Config::InvalidConfiguration do
        Runners::Config.new(file)
      end
      assert_equal "The value of the attribute `linter` in your `sider.yml` is invalid. Please fix and retry.", exn.message
      assert_equal yaml, exn.raw_content
    end
  end

  def test_content_with_ignore_section
    mktmpdir do |dir|
      file = (dir / CONFIG_FILE_NAME).tap { _1.write <<~YAML }
        ---
        ignore:
          - ".pdf"
          - ".mp4"
          - "images/**"
      YAML
      assert_equal({ linter: nil, ignore: %w[.pdf .mp4 images/**], branches: nil },
                   Runners::Config.new(file).content)
    end
  end

  def test_content_with_branches_section
    mktmpdir do |dir|
      file = (dir / CONFIG_FILE_NAME).tap { _1.write <<~YAML }
        ---
        branches:
          exclude:
            - master
            - /^release-.*$/
      YAML
      assert_equal({ linter: nil, ignore: nil, branches: { exclude: %w[master /^release-.*$/] } },
                   Runners::Config.new(file).content)
    end
  end

  def test_content_with_broken_yaml
    mktmpdir do |dir|
      file = (dir / CONFIG_FILE_NAME).tap { _1.write "@" }
      exn = assert_raises Runners::Config::BrokenYAML do
        Runners::Config.new(file)
      end
      assert_equal "Your `sider.yml` is broken at line 1 and column 1. Please fix and retry.", exn.message
    end
  end

  def test_path_name
    mktmpdir do |dir|
      assert_equal CONFIG_FILE_NAME, Runners::Config.new(nil).path_name

      file_1 = (dir / CONFIG_FILE_NAME).tap { _1.write "" }
      assert_equal CONFIG_FILE_NAME, Runners::Config.new(file_1).path_name

      file_1.delete

      file_2 = (dir / OLD_CONFIG_FILE_NAME).tap { _1.write "" }
      assert_equal OLD_CONFIG_FILE_NAME, Runners::Config.new(file_2).path_name
    end
  end

  def test_ignore_patterns
    mktmpdir do |dir|
      assert_equal [], Runners::Config.new(nil).ignore_patterns

      file = (dir / CONFIG_FILE_NAME).tap { _1.write "ignore: abc" }
      assert_equal %w[abc], Runners::Config.new(file).ignore_patterns

      file.write <<~YAML
        ignore:
          - "*.mp4"
          - docs/**/*.pdf
      YAML
      assert_equal %w[*.mp4 docs/**/*.pdf], Runners::Config.new(file).ignore_patterns
    end
  end

  def test_linter
    mktmpdir do |dir|
      file = (dir / CONFIG_FILE_NAME).tap { _1.write <<~YAML }
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
      }, Runners::Config.new(file).linter("eslint"))
    end
  end

  def test_linter_default
    mktmpdir do |dir|
      file  = (dir / CONFIG_FILE_NAME).tap { _1.write "" }
      assert_equal({}, Runners::Config.new(file).linter("eslint"))
    end
  end

  def test_linter?
    mktmpdir do |dir|
      file = (dir / CONFIG_FILE_NAME).tap { _1.write <<~YAML }
        linter:
          eslint: { root_dir: "src" }
      YAML
      config = Runners::Config.new(file)
      assert config.linter?("eslint")
      refute config.linter?("foo")

      file.write ""
      refute Runners::Config.new(file).linter?("foo")
    end
  end

  def test_removed_go_tools_do_not_break
    mktmpdir do |dir|
      file = (dir / CONFIG_FILE_NAME).tap { _1.write <<~YAML }
        linter:
          golint:
            root_dir: src/
          go_vet:
            root_dir: lib/
          gometalinter:
            root_dir: module/
            import_path: foo
      YAML
      config = Runners::Config.new(file)
      assert_equal({ root_dir: "src/" }, config.linter("golint"))
      assert_equal({ root_dir: "lib/" }, config.linter("go_vet"))
      assert_equal({ root_dir: "module/", import_path: "foo" }, config.linter("gometalinter"))
    end
  end
end
