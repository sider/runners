require "test_helper"

class WorkspaceTest < Minitest::Test
  include TestHelper

  Workspace = Runners::Workspace

  def test_prepare
    json = JSON.dump(source: { head: "commit", git_url: "https://github.com/foo/bar" })
    options = Runners::Options.new(json, StringIO.new, StringIO.new)
    filter = Runners::SensitiveFilter.new(options: options)
    workspace = Workspace.prepare(options: options, trace_writer: new_trace_writer(filter: filter), working_dir: Pathname("/"))
    assert_instance_of Workspace::Git, workspace
  end

  def test_open
    with_workspace(head: "330716dcd50a7a2c7d8ff79d74035c05453528b4", base: "cd33ab59ef3d75e54e6d49c000bc8f141d94d356") do |workspace|
      workspace.open do |_git_ssh_path, changes|
        assert_path_exists workspace.working_dir / "README.md"
        assert_path_exists workspace.working_dir / ".git"
        refute_path_exists workspace.working_dir / "README.markdown"

        assert_equal Set[Pathname("README.md")], changes.changed_paths
        assert_equal Set[], changes.unchanged_paths
      end
    end
  end

  def test_open_without_base
    with_workspace(head: "330716dcd50a7a2c7d8ff79d74035c05453528b4", base: nil) do |workspace|
      workspace.open do |_git_ssh_path, changes|
        assert_path_exists workspace.working_dir / "README.md"
        refute_path_exists workspace.working_dir / "README.markdown"

        assert_equal Set[Pathname("README.md")], changes.changed_paths
        assert_equal Set[], changes.unchanged_paths
      end
    end
  end

  def test_git_ssh_path_is_nil
    with_workspace do |workspace|
      workspace.open do |git_ssh_path|
        assert_nil git_ssh_path
      end
    end
  end

  def test_git_ssh_path_is_pathname
    with_workspace(ssh_key: data("ruby_private_gem_deploy_key").read) do |workspace|
      workspace.open do |git_ssh_path|
        assert_path_exists git_ssh_path
        assert_equal "config", git_ssh_path.basename.to_path

        ssh_dir = git_ssh_path.parent
        all_files = ssh_dir.glob("**/*").map { _1.relative_path_from(ssh_dir).to_path }.sort

        assert_equal ["config", "key", "known_hosts"], all_files
        assert_equal "100600", "%o" % (ssh_dir / "config").stat.mode
        assert_equal "100600", "%o" % (ssh_dir / "key").stat.mode
        assert_equal "100600", "%o" % (ssh_dir / "known_hosts").stat.mode

        system(
          { "GIT_SSH_COMMAND" => "ssh -F '#{git_ssh_path}'" },
          "git", "clone", "--depth=1", "--quiet", "git@github.com:sider/ruby_private_gem.git",
          { chdir: workspace.working_dir.to_path, exception: true }
        )
        assert_path_exists workspace.working_dir / "ruby_private_gem" / "README.md"
      end
    end
  end
end
