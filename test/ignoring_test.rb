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

  def assert_exist(path)
    assert path.file?
  end

  def assert_not_exist(path)
    refute path.file?
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
      subject.delete_ignored_files!

      assert_not_exist dir / "examples/foo/out/index.html"
      assert_not_exist dir / "examples/bar/out/index.html"
      assert_exist dir / "examples/bar/pub/index.html"
      assert_not_exist dir / "test/a/outA/index.html"
      assert_not_exist dir / "test/b/outB/index.html"
      assert_not_exist dir / "test/c/out.txt"
      assert_not_exist dir / ".idea/workspace.xml"
      assert_exist dir / "src/index.js"
      assert_exist dir / "src/app/index.js"
      assert_not_exist dir / "src/.idea/workspace.xml"
      assert_not_exist dir / "npm.log"
      assert_not_exist dir / "yarn.log"
      assert_exist dir / "npm.log.bak"

      refute((dir / ".git").exist?)

      assert_equal "Deleting ignored files...", trace_writer.writer[0][:message]
      assert_equal <<~MSG.chomp, trace_writer.writer[6][:message]
        .idea/workspace.xml
        examples/bar/out/index.html
        examples/foo/out/index.html
        npm.log
        src/.idea/workspace.xml
        test/a/outA/index.html
        test/b/outB/index.html
        test/c/out.txt
        yarn.log
      MSG
    end
  end

  def test_delete_ignored_files_when_the_specified_files_do_not_exist
    mktmpdir do |dir|
      config = new_config <<~YAML, dir: dir
        ignore: "a/b/c/d/**.txt"
      YAML

      subject = Ignoring.new(working_dir: dir, trace_writer: trace_writer, config: config)
      subject.delete_ignored_files!

      assert_equal "Deleting ignored files...", trace_writer.writer[0][:message]
      assert_match %r{^-> [\d\.]+s}, trace_writer.writer[6][:message]
    end
  end

  def test_delete_ignored_files_when_users_gitignore_exists
    mktmpdir do |dir|
      new_file dir / ".gitignore", content: "foo"

      config = new_config <<~YAML, dir: dir
        ignore: "bar"
      YAML

      subject = Ignoring.new(working_dir: dir, trace_writer: trace_writer, config: config)
      subject.delete_ignored_files!

      assert_equal "Deleting ignored files...", trace_writer.writer[0][:message]
      assert_equal "foo", (dir / ".gitignore").read
    end
  end
end
