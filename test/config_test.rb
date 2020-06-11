require_relative "test_helper"

class ConfigTest < Minitest::Test
  include TestHelper

  def test_content_without_sider_yml
    mktmpdir do |path|
      assert_equal({}, Runners::Config.new(path).content)
    end
  end

  def test_content_with_empty_sider_yml
    mktmpdir do |path|
      (path / "sider.yml").write("---")
      assert_equal({}, Runners::Config.new(path).content)
    end

    mktmpdir do |path|
      (path / "sider.yml").write("")
      assert_equal({}, Runners::Config.new(path).content)
    end
  end

  def test_content_with_linter_section
    mktmpdir do |path|
      (path / "sider.yml").write(<<~YAML)
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
          code_sniffer: nil,
          coffeelint: nil,
          cppcheck: nil,
          cpplint: nil,
          detekt: nil,
          eslint: {
            root_dir: nil,
            npm_install: nil,
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
        Runners::Config.new(path).content,
      )
    end
  end

  def test_content_with_unknown_linter
    mktmpdir do |path|
      yaml = <<~YAML
        ---
        linter:
          unknown_linter:
            config: abc
      YAML
      (path / "sider.yml").write(yaml)
      exn = assert_raises Runners::Config::InvalidConfiguration do
        Runners::Config.new(path)
      end
      assert_equal "The attribute `$.linter.unknown_linter` in your `sider.yml` is unsupported. Please fix and retry.", exn.message
      assert_equal yaml, exn.raw_content
    end

    mktmpdir do |path|
      yaml = <<~YAML
        ---
        linter: []
      YAML
      (path / "sider.yml").write(yaml)
      exn = assert_raises Runners::Config::InvalidConfiguration do
        Runners::Config.new(path)
      end
      assert_equal "The value of the attribute `$.linter` in your `sider.yml` is invalid. Please fix and retry.", exn.message
      assert_equal yaml, exn.raw_content
    end
  end

  def test_content_with_ignore_section
    mktmpdir do |path|
      (path / "sider.yml").write(<<~YAML)
        ---
        ignore:
          - ".pdf"
          - ".mp4"
          - "images/**"
      YAML
      assert_equal({ linter: nil, ignore: %w[.pdf .mp4 images/**], branches: nil }, Runners::Config.new(path).content)
    end
  end

  def test_content_with_branches_section
    mktmpdir do |path|
      (path / "sider.yml").write(<<~YAML)
        ---
        branches:
          exclude:
            - master
            - /^release-.*$/
      YAML
      assert_equal({ linter: nil, ignore: nil, branches: { exclude: %w[master /^release-.*$/] } }, Runners::Config.new(path).content)
    end
  end

  def test_content_with_broken_yaml
    mktmpdir do |path|
      (path / "sider.yml").write(<<~YAML)
        @
      YAML
      exn = assert_raises Runners::Config::BrokenYAML do
        Runners::Config.new(path)
      end
      assert_equal "Your `sider.yml` is broken at line 1 and column 1. Please fix and retry.", exn.message
    end
  end

  def test_path_name
    mktmpdir do |path|
      assert_equal "sider.yml", Runners::Config.new(path).path_name
    end

    mktmpdir do |path|
      (path / "sider.yml").write("")
      assert_equal "sider.yml", Runners::Config.new(path).path_name
    end

    mktmpdir do |path|
      (path / "sideci.yml").write("")
      assert_equal "sideci.yml", Runners::Config.new(path).path_name
    end

    mktmpdir do |path|
      (path / "sider.yml").write("")
      (path / "sideci.yml").write("")
      assert_equal "sider.yml", Runners::Config.new(path).path_name
    end
  end

  def test_ignore
    mktmpdir do |path|
      assert_equal [], Runners::Config.new(path).ignore
    end

    mktmpdir do |path|
      (path / "sider.yml").write("ignore: abc")
      assert_equal %w[abc], Runners::Config.new(path).ignore
    end

    mktmpdir do |path|
      (path / "sider.yml").write(<<~YAML)
        ignore:
          - "*.mp4"
          - docs/**/*.pdf
      YAML
      assert_equal %w[*.mp4 docs/**/*.pdf], Runners::Config.new(path).ignore
    end
  end

  def test_linter
    mktmpdir do |path|
      (path / "sider.yml").write(<<~YAML)
        linter:
          eslint:
            ext: .js
      YAML
      assert_equal({
        ext: ".js",
        root_dir: nil,
        npm_install: nil,
        dir: nil,
        config: nil,
        "ignore-path": nil,
        "ignore-pattern": nil,
        "no-ignore": nil,
        global: nil,
        quiet: nil,
        options: nil,
      }, Runners::Config.new(path).linter("eslint"))
    end
  end

  def test_linter_default
    mktmpdir do |path|
      (path / "sider.yml").write("")
      assert_equal({}, Runners::Config.new(path).linter("eslint"))
    end
  end

  def test_linter?
    mktmpdir do |path|
      (path / "sider.yml").write(<<~YAML)
        linter:
          eslint: { root_dir: "src" }
      YAML
      config = Runners::Config.new(path)
      assert config.linter?("eslint")
      refute config.linter?("foo")

      (path / "sider.yml").write("")
      refute Runners::Config.new(path).linter?("foo")
    end
  end

  def test_removed_go_tools_do_not_break
    mktmpdir do |path|
      (path / "sider.yml").write(<<~YAML)
        linter:
          golint:
            root_dir: src/
          go_vet:
            root_dir: lib/
          gometalinter:
            root_dir: module/
            import_path: foo
      YAML
      config = Runners::Config.new(path)
      assert_equal({ root_dir: "src/" }, config.linter("golint"))
      assert_equal({ root_dir: "lib/" }, config.linter("go_vet"))
      assert_equal({ root_dir: "module/", import_path: "foo" }, config.linter("gometalinter"))
    end
  end
end
