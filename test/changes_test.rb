require_relative "test_helper"

class ChangesTest < Minitest::Test
  include TestHelper

  Changes = Runners::Changes
  Issue = Runners::Issue
  Location = Runners::Location

  def patches
    GitDiffParser.parse(<<-PATCH)
diff --git a/group.rb b/group.rb
index f1bdf42..5c56bf0 100644
--- a/group.rb
+++ b/group.rb
@@ -1,2 +1,4 @@
 class Group
+  def a
+  end
 end
diff --git a/user.rb b/user.rb
index 740c016..cc737a5 100644
--- a/user.rb
+++ b/user.rb
@@ -1,6 +1,4 @@
 class User
-
-
-  def ok
+  def foo
   end
 end
    PATCH
  end

  def test_changed_paths
    mktmpdir do |base_path|
      mktmpdir do |head_path|
        mktmpdir do |working_path|
          base_path.join("unchanged.rb").write("hello world")
          head_path.join("unchanged.rb").write("hello world")
          working_path.join("unchanged.rb").write("hello world")

          base_path.join("changed1.rb").write("Hello World")
          head_path.join("changed1.rb").write("Open sesame")
          working_path.join("changed1.rb").write("Open sesame")

          head_path.join("changed2.rb").write("Review less, merge faster")
          working_path.join("changed2.rb").write("Review less, merge faster")

          working_path.join("built1.rb").write("Build apps with confidence")

          head_path.join("built2.rb").write("Built for developers")
          working_path.join("built2.rb").write("Healthy code ships faster.")

          base_path.join("ignored.rb").write("Read, write, and share stories that matter")
          head_path.join("ignored.rb").write("Reinventing teamwork")

          changes = Changes.calculate(base_dir: base_path, head_dir: head_path, working_dir: working_path, patches: nil)

          assert_equal Set[Pathname("changed1.rb"), Pathname("changed2.rb")], changes.changed_paths
          assert_equal Set[Pathname("unchanged.rb")], changes.unchanged_paths
          assert_equal Set[Pathname("built1.rb"), Pathname("built2.rb")], changes.untracked_paths
        end
      end
    end
  end

  def test_changed_paths_with_empty_base
    # This is simulation for diff disabled mode, put everything to changed_paths
    mktmpdir do |base_path|
      mktmpdir do |head_path|
        mktmpdir do |working_path|
          head_path.join("unchanged.rb").write("hello world")
          working_path.join("unchanged.rb").write("hello world")

          head_path.join("changed1.rb").write("Open sesame")
          working_path.join("changed1.rb").write("Open sesame")

          head_path.join("changed2.rb").write("Review less, merge faster")
          working_path.join("changed2.rb").write("Review less, merge faster")

          working_path.join("built1.rb").write("Build apps with confidence")

          head_path.join("built2.rb").write("Built for developers")
          working_path.join("built2.rb").write("Healthy code ships faster.")

          head_path.join("ignored.rb").write("Reinventing teamwork")

          changes = Changes.calculate(base_dir: base_path, head_dir: head_path, working_dir: working_path, patches: nil)

          assert_equal Set[Pathname("changed1.rb"), Pathname("changed2.rb"), Pathname("unchanged.rb")], changes.changed_paths
          assert_equal Set[], changes.unchanged_paths
          assert_equal Set[Pathname("built1.rb"), Pathname("built2.rb")], changes.untracked_paths
        end
      end
    end
  end

  def test_delete_unchanged
    mktmpdir do |dir|
      dir.join("file1").write("foo")
      dir.join("file2").write("foo")
      dir.join("file3").write("foo")

      changes = Changes.new(changed_paths: [], unchanged_paths: [Pathname("file1"), Pathname("file2"), Pathname("file3")], untracked_paths: [], patches: nil)

      changes.delete_unchanged(dir: dir)

      refute dir.join("file1").file?
      refute dir.join("file2").file?
      refute dir.join("file3").file?
    end
  end

  def test_delete_unchanged_with_pattern
    mktmpdir do |dir|
      files = Dir.chdir(dir) do
        Pathname("some").mkdir
        [
          Pathname("file1"),
          Pathname("file2"),
          Pathname("file3"),
          Pathname("some") / "foo.rb",
          Pathname("some") / "bar.py",
          Pathname("some") / "baz.js",
          Pathname("some") / "xyz.md",
        ].each { |f| f.write("") }
      end

      changes = Changes.new(changed_paths: [], unchanged_paths: files, untracked_paths: [], patches: nil)
      changes.delete_unchanged(dir: dir, only: ["file[2-3]", "*.{rb,py}"], except: ["file3", "*.{py,md}"])

      assert dir.join("file1").file?
      refute dir.join("file2").file?
      assert dir.join("file3").file?
      refute dir.join("some", "foo.rb").file?
      assert dir.join("some", "bar.py").file?
      assert dir.join("some", "baz.js").file?
      assert dir.join("some", "xyz.md").file?
    end
  end

  def test_symlink
    mktmpdir do |base_path|
      mktmpdir do |head_path|
        mktmpdir do |working_path|
          working_path.join("dir").mkdir
          working_path.join("foo").write("bar")
          working_path.join("baz").make_symlink(Pathname("foo"))
          working_path.join("link").make_symlink(Pathname("../aaaaa"))

          changes = Changes.calculate(base_dir: base_path, head_dir: head_path, working_dir: working_path, patches: nil)

          assert changes.untracked_paths.include?(Pathname("foo"))
          assert changes.untracked_paths.include?(Pathname("baz"))
          refute changes.untracked_paths.include?(Pathname("link"))
        end
      end
    end
  end

  def test_include
    mktmpdir do |base_path|
      mktmpdir do |head_path|
        mktmpdir do |working_path|
          (working_path / "group.rb").write(<<~GROUP)
            class Group
              def a
              end
            end
          GROUP
          (working_path / "user.rb").write(<<~USER)
            class User
              def foo
              end
            end
          USER

          changes = Changes.calculate(base_dir: base_path, head_dir: head_path, working_dir: working_path, patches: patches)

          refute changes.include?(Issue.new(path: Pathname("group.rb"), location: Location.new(start_line: 1), id: "a", message: "a", links: []))
          assert changes.include?(Issue.new(path: Pathname("group.rb"), location: Location.new(start_line: 2), id: "a", message: "a", links: []))
          assert changes.include?(Issue.new(path: Pathname("group.rb"), location: Location.new(start_line: 3), id: "a", message: "a", links: []))
          refute changes.include?(Issue.new(path: Pathname("group.rb"), location: Location.new(start_line: 4), id: "a", message: "a", links: []))
          assert changes.include?(Issue.new(path: Pathname("user.rb"), location: nil, id: "a", message: "a", links: []))
          refute changes.include?(Issue.new(path: Pathname("user.rb"), location: Location.new(start_line: 1), id: "a", message: "a", links: []))
          assert changes.include?(Issue.new(path: Pathname("user.rb"), location: Location.new(start_line: 2), id: "a", message: "a", links: []))
          refute changes.include?(Issue.new(path: Pathname("user.rb"), location: Location.new(start_line: 3), id: "a", message: "a", links: []))
          refute changes.include?(Issue.new(path: Pathname("user.rb"), location: Location.new(start_line: 4), id: "a", message: "a", links: []))
          refute changes.include?(Issue.new(path: Pathname("foo.rb"), location: nil, id: "a", message: "a", links: []))
          refute changes.include?(Issue.new(path: Pathname("foo.rb"), location: Location.new(start_line: 2), id: "a", message: "a", links: []))
        end
      end
    end
  end
end
