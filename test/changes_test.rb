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

  def test_calculate
    mktmpdir do |dir|
      (dir / "changed_2.rb").write("hello world")
      (dir / "changed_1.rb").write("hello world")
      (dir / ".added_1.rb").write("")
      (dir / ".git").mkpath
      (dir / ".git" / "config").write("")
      (dir / ".git" / "info").mkpath
      (dir / ".git" / "info" / "refs").write("")
      (dir / ".github").mkpath
      (dir / ".github" / ".added_2.rb").write("")
      (dir / "empty_dir").mkpath

      changes = Changes.calculate(working_dir: dir)

      assert_equal Set[Pathname(".added_1.rb"),
                       Pathname(".github") / ".added_2.rb",
                       Pathname("changed_1.rb"),
                       Pathname("changed_2.rb")], changes.changed_paths
      assert_equal Set[], changes.unchanged_paths
    end
  end

  def test_calculate_by_patches
    mktmpdir do |dir|
      (dir / "changed_2.rb").write("hello world")
      (dir / "changed_1.rb").write("hello world")
      (dir / ".added_1.rb").write("")
      (dir / ".git").mkpath
      (dir / ".git" / "config").write("")
      (dir / ".github").mkpath
      (dir / ".github" / ".added_2.rb").write("")
      (dir / "empty_dir").mkpath

      changes = Changes.calculate_by_patches(working_dir: dir, patches: patches)

      assert_equal Set[Pathname("group.rb"),
                       Pathname("user.rb")], changes.changed_paths
      assert_equal Set[Pathname(".added_1.rb"),
                       Pathname(".github") / ".added_2.rb",
                       Pathname("changed_1.rb"),
                       Pathname("changed_2.rb")], changes.unchanged_paths
    end
  end

  def test_delete_unchanged
    mktmpdir do |dir|
      dir.join("file1").write("foo")
      dir.join("file2").write("foo")
      dir.join("file3").write("foo")

      changes = Changes.new(changed_paths: [], unchanged_paths: [Pathname("file1"), Pathname("file2"), Pathname("file3")], patches: nil)

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

      changes = Changes.new(changed_paths: [], unchanged_paths: files, patches: nil)
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

  def test_include
    mktmpdir do |dir|
      (dir / "group.rb").write(<<~GROUP)
        class Group
          def a
          end
        end
      GROUP
      (dir / "user.rb").write(<<~USER)
        class User
          def foo
          end
        end
      USER

      changes = Changes.calculate(working_dir: dir)

      assert_includes changes, Issue.new(path: Pathname("group.rb"), location: Location.new(start_line: 1), id: "a", message: "a", links: [])
      assert_includes changes, Issue.new(path: Pathname("user.rb"), location: nil, id: "a", message: "a", links: [])
      refute_includes changes, Issue.new(path: Pathname("foo.rb"), location: nil, id: "a", message: "a", links: [])
    end
  end

  def test_include_with_patches
    mktmpdir do |dir|
      (dir / "group.rb").write(<<~GROUP)
        class Group
          def a
          end
        end
      GROUP
      (dir / "user.rb").write(<<~USER)
        class User
          def foo
          end
        end
      USER

      changes = Changes.calculate_by_patches(working_dir: dir, patches: patches)

      refute_includes changes, Issue.new(path: Pathname("group.rb"), location: Location.new(start_line: 1), id: "a", message: "a", links: [])
      assert_includes changes, Issue.new(path: Pathname("group.rb"), location: Location.new(start_line: 2), id: "a", message: "a", links: [])
      assert_includes changes, Issue.new(path: Pathname("group.rb"), location: Location.new(start_line: 3), id: "a", message: "a", links: [])
      refute_includes changes, Issue.new(path: Pathname("group.rb"), location: Location.new(start_line: 4), id: "a", message: "a", links: [])
      assert_includes changes, Issue.new(path: Pathname("user.rb"), location: nil, id: "a", message: "a", links: [])
      refute_includes changes, Issue.new(path: Pathname("user.rb"), location: Location.new(start_line: 1), id: "a", message: "a", links: [])
      assert_includes changes, Issue.new(path: Pathname("user.rb"), location: Location.new(start_line: 2), id: "a", message: "a", links: [])
      refute_includes changes, Issue.new(path: Pathname("user.rb"), location: Location.new(start_line: 3), id: "a", message: "a", links: [])
      refute_includes changes, Issue.new(path: Pathname("user.rb"), location: Location.new(start_line: 4), id: "a", message: "a", links: [])
      refute_includes changes, Issue.new(path: Pathname("foo.rb"), location: nil, id: "a", message: "a", links: [])
      refute_includes changes, Issue.new(path: Pathname("foo.rb"), location: Location.new(start_line: 2), id: "a", message: "a", links: [])
    end
  end
end
