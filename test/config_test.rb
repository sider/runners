require_relative "test_helper"

class ConfigTest < Minitest::Test
  include TestHelper

  def setup
    schema = StrongJSON.new do
      let :config, object(dir: string)
    end

    Runners::Schema::Config.register name: :foo, schema: schema.config
  end

  def teardown
    Runners::Schema::Config.unregister name: :foo
  end

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
          foo:
            dir: src/
      YAML
      assert_equal(
        { linter: { foo: { dir: "src/" } }, ignore: nil, branches: nil },
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
          foo:
            dir: src/
      YAML
      assert_equal({ dir: "src/" }, Runners::Config.new(path).linter("foo"))
    end
  end

  def test_linter_default
    mktmpdir do |path|
      (path / "sider.yml").write("")
      assert_equal({}, Runners::Config.new(path).linter("foo"))
    end
  end
end
