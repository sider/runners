require_relative "test_helper"

class WorkspaceTest < Minitest::Test
  include TestHelper

  Workspace = Runners::Workspace

  def test_prepare
    with_runners_options_env(source: { head: (Pathname(__dir__) + "data/foo.tgz").to_s }) do
      options = Runners::Options.new(StringIO.new, StringIO.new)
      workspace = Workspace.prepare(options: options, trace_writer: Runners::TraceWriter.new(writer: []), working_dir: Pathname("/"))
      assert_instance_of Workspace::File, workspace
    end

    with_runners_options_env(source: { head: "https://example.com" }) do
      options = Runners::Options.new(StringIO.new, StringIO.new)
      workspace = Workspace.prepare(options: options, trace_writer: Runners::TraceWriter.new(writer: []), working_dir: Pathname("/"))
      assert_instance_of Workspace::HTTP, workspace
    end

    with_runners_options_env(source: { head: "commit", git_http_url: "https://github.com", owner: "foo", repo: "bar" }) do
      options = Runners::Options.new(StringIO.new, StringIO.new)
      workspace = Workspace.prepare(options: options, trace_writer: Runners::TraceWriter.new(writer: []), working_dir: Pathname("/"))
      assert_instance_of Workspace::Git, workspace
    end

    with_runners_options_env(source: { head: "ftp:///" }) do
      options = Runners::Options.new(StringIO.new, StringIO.new)
      assert_raises(ArgumentError) do
        Workspace.prepare(options: options, trace_writer: Runners::TraceWriter.new(writer: []), working_dir: Pathname("/"))
      end
    end
  end

  def test_open
    with_workspace(base: (Pathname(__dir__) + "data/encrypted.tar.gz").to_s,
                   base_key: "CfAlFi2Uq3aiS3qSnq3Wq0gQWieTbt3151Z+iFXnE3o=",
                   head: (Pathname(__dir__) + "data/foo.tgz").to_s,
                   head_key: nil,
    ) do |workspace|
      workspace.open do |_git_ssh_path, changes|
        assert (workspace.working_dir + "querly.gemspec").file?
        refute (workspace.working_dir + "foo.tgz").file?

        refute changes.changed_paths.empty?
        refute changes.unchanged_paths.empty?
      end
    end
  end

  def test_open_for_git_source
    with_workspace(head: "998bc02a913e3899f3a1cd327e162dd54d489a4b", base: "abe1cfc294c8d39de7484954bf8c3d7792fd8ad1",
                   git_http_url: "https://github.com", owner: "sider", repo: "runners", pull_number: 533) do |workspace|
      workspace.open do |_git_ssh_path, changes|
        assert (workspace.working_dir / "README.md").file?
        refute (workspace.working_dir / ".git").exist?

        refute changes.changed_paths.empty?
        refute changes.unchanged_paths.empty?

        refute workspace.root_tmp_dir.empty?
      end
      refute workspace.root_tmp_dir.exist?
    end
  end

  def test_open_without_base
    with_workspace(base: nil, base_key: nil) do |workspace|
      workspace.open do |_git_ssh_path, changes|
        assert (workspace.working_dir + "querly.gemspec").file?
        refute (workspace.working_dir + "foo.tgz").file?

        refute changes.changed_paths.empty?
        assert changes.unchanged_paths.empty?
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
    with_workspace(ssh_key: (Pathname(__dir__) / "data/ssh_key").read) do |workspace|
      workspace.open do |git_ssh_path|
        refute_nil git_ssh_path

        Open3.capture3(
          { "GIT_SSH" => git_ssh_path.to_s },
          "git", "clone", "--depth=1", "git@github.com:sider/runners.git",
          { chdir: workspace.working_dir.to_s }
        )
        assert (workspace.working_dir / "runners/sider.yml").file?
      end
    end
  end
end
