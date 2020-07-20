require_relative "test_helper"

class WorkspaceTest < Minitest::Test
  include TestHelper

  Workspace = Runners::Workspace

  def test_prepare
    with_runners_options_env(source: { head: "commit", git_http_url: "https://github.com", owner: "foo", repo: "bar" }) do
      options = Runners::Options.new(StringIO.new, StringIO.new)
      filter = Runners::SensitiveFilter.new(options: options)
      workspace = Workspace.prepare(options: options, trace_writer: new_trace_writer(filter: filter), working_dir: Pathname("/"))
      assert_instance_of Workspace::Git, workspace
    end

    with_runners_options_env(source: { head: "ftp:///" }) do
      options = Runners::Options.new(StringIO.new, StringIO.new)
      filter = Runners::SensitiveFilter.new(options: options)
      error = assert_raises(ArgumentError) do
        Workspace.prepare(options: options, trace_writer: new_trace_writer(filter: filter), working_dir: Pathname("/"))
      end
      assert_equal "The specified options #{options.inspect} is not supported", error.message
    end
  end

  def test_open
    with_workspace(base: base_commit) do |workspace|
      workspace.open do |_git_ssh_path, changes|
        assert_path_exists workspace.working_dir / "README.md"
        assert_path_exists workspace.working_dir / ".git"
        refute_path_exists workspace.working_dir / "README.markdown"

        refute_empty changes.changed_paths
        refute_empty changes.unchanged_paths
      end
    end
  end

  def test_open_without_base
    with_workspace(base: nil) do |workspace|
      workspace.open do |_git_ssh_path, changes|
        assert_path_exists workspace.working_dir / "README.md"
        refute_path_exists workspace.working_dir / "README.markdown"

        refute_empty changes.changed_paths
        assert_empty changes.unchanged_paths
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
    with_workspace(ssh_key: data("ssh_key").read) do |workspace|
      workspace.open do |git_ssh_path|
        refute_nil git_ssh_path

        Open3.capture3(
          { "GIT_SSH" => git_ssh_path.to_s },
          "git", "clone", "--depth=1", "git@github.com:sider/runners_test.git",
          { chdir: workspace.working_dir.to_s }
        )
        assert_path_exists workspace.working_dir / "runners_test" / "README.md"
      end
    end
  end
end
