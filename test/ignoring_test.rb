require_relative "test_helper"

class IgnoringTest < Minitest::Test
  include TestHelper

  Ignoring = Runners::Ignoring

  def trace_writer
    @trace_writer ||= new_trace_writer
  end

  def new_config(yaml, dir:)
    path = dir / "sider.yml"
    path.write yaml
    Runners::Config.new(dir)
  end

  def new_file(path, content: "")
    path.tap do |f|
      f.parent.mkpath
      f.write content
    end
  end

  def test_delete_ignored_files
    mktmpdir do |dir|
      config = new_config <<~YAML, dir: dir
        ignore:
          - examples/**/out
          - test/**/out*
          - ".idea"
          - "*.log"
      YAML

      new_file dir / "examples/foo/out/index.html"
      new_file dir / "examples/bar/out/index.html"
      new_file dir / "examples/bar/pub/index.html"
      new_file dir / "test/a/outA/index.html"
      new_file dir / "test/b/outB/index.html"
      new_file dir / "test/c/out.txt"
      new_file dir / ".idea/workspace.xml"
      new_file dir / "src/index.js"
      new_file dir / "src/app/index.js"
      new_file dir / "src/.idea/workspace.xml"
      new_file dir / "npm.log"
      new_file dir / "yarn.log"
      new_file dir / "npm.log.bak"

      subject = Ignoring.new(working_dir: dir, trace_writer: trace_writer, config: config)
      assert_equal [
        ".idea/workspace.xml",
        "examples/bar/out/index.html",
        "examples/foo/out/index.html",
        "npm.log",
        "src/.idea/workspace.xml",
        "test/a/outA/index.html",
        "test/b/outB/index.html",
        "test/c/out.txt",
        "yarn.log",
      ], subject.delete_ignored_files!

      refute_path_exists dir / "examples/foo/out/index.html"
      refute_path_exists dir / "examples/bar/out/index.html"
      assert_path_exists dir / "examples/bar/pub/index.html"
      refute_path_exists dir / "test/a/outA/index.html"
      refute_path_exists dir / "test/b/outB/index.html"
      refute_path_exists dir / "test/c/out.txt"
      refute_path_exists dir / ".idea/workspace.xml"
      assert_path_exists dir / "src/index.js"
      assert_path_exists dir / "src/app/index.js"
      refute_path_exists dir / "src/.idea/workspace.xml"
      refute_path_exists dir / "npm.log"
      refute_path_exists dir / "yarn.log"
      assert_path_exists dir / "npm.log.bak"
    end
  end

  def test_delete_ignored_files_when_the_specified_files_do_not_exist
    mktmpdir do |dir|
      config = new_config <<~YAML, dir: dir
        ignore: "a/b/c/d/**.txt"
      YAML

      subject = Ignoring.new(working_dir: dir, trace_writer: trace_writer, config: config)
      assert_empty subject.delete_ignored_files!
    end
  end

  def test_delete_ignored_files_when_users_gitignore_exists
    mktmpdir do |dir|
      new_file dir / ".gitignore", content: "foo"
      new_file dir / "foo"
      new_file dir / "bar"

      config = new_config <<~YAML, dir: dir
        ignore: "bar"
      YAML

      subject = Ignoring.new(working_dir: dir, trace_writer: trace_writer, config: config)
      assert_equal ["bar"], subject.delete_ignored_files!
    end
  end
end
