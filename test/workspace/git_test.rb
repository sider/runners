require_relative "../test_helper"

class WorkspaceGitTest < Minitest::Test
  include TestHelper

  GitBlameInfo = Runners::GitBlameInfo

  def workspace_params
    {
      head: "998bc02a913e3899f3a1cd327e162dd54d489a4b",
      git_http_url: "https://github.com",
      owner: "sider",
      repo: "runners",
      pull_number: 533,
    }
  end

  def workspace_params_with_base
    workspace_params.merge(base: "abe1cfc294c8d39de7484954bf8c3d7792fd8ad1")
  end

  def test_instance_class
    with_workspace(**workspace_params) do |workspace|
      assert_instance_of Runners::Workspace::Git, workspace
    end
  end

  def test_prepare_head_source
    with_workspace(**workspace_params) do |workspace|
      workspace.send(:prepare_head_source, nil)

      dest = workspace.working_dir
      refute_empty dest.children
      assert_path_exists dest / "README.md"
      assert_path_exists dest / ".git"
    end
  end

  def test_remote_url
    with_workspace(**workspace_params) do |workspace|
      assert_equal URI("https://github.com/sider/runners"), workspace.send(:remote_url)
    end
  end

  def test_remote_url_with_token
    params = workspace_params.merge(git_http_userinfo: "x-access-token:v1.aaabbbcccdddeeefffgggbc06400127f248a82ac")
    with_workspace(**params) do |workspace|
      assert_equal URI("https://x-access-token:v1.aaabbbcccdddeeefffgggbc06400127f248a82ac@github.com/sider/runners"), workspace.send(:remote_url)
    end
  end

  def test_git_fetch_args
    with_workspace(**workspace_params) do |workspace|
      assert_equal %w[
        --quiet --no-tags --no-recurse-submodules origin
        +refs/heads/*:refs/remotes/origin/*
        +refs/pull/533/head:refs/remotes/pull/533/head
      ], workspace.send(:git_fetch_args)
    end
  end

  def test_git_fetch_args_without_pull_number
    params = workspace_params.tap { |p| p.delete(:pull_number) }
    with_workspace(**params) do |workspace|
      assert_equal %w[
        --quiet --no-tags --no-recurse-submodules origin
        +refs/heads/*:refs/remotes/origin/*
      ], workspace.send(:git_fetch_args)
    end
  end

  def test_patches_returns_nil_because_base_is_nil
    with_workspace(**workspace_params) do |workspace|
      assert_nil workspace.send(:patches)
    end
  end

  def test_patches_returns_patches
    with_workspace(**workspace_params_with_base) do |workspace|
      workspace.send(:prepare_head_source, nil)
      assert_instance_of GitDiffParser::Patches, workspace.send(:patches)
    end
  end

  def test_patches_not_calling_git_diff_twice
    with_workspace(**workspace_params_with_base) do |workspace|
      workspace.send(:prepare_head_source, nil)
      p1 = workspace.send(:patches)
      p2 = workspace.send(:patches)
      assert_same p1, p2
      assert_equal 1, workspace.trace_writer.writer.count { |e| e[:command_line]&.slice(0, 2) == %w[git diff] }
    end
  end

  def test_git_blame_info
    with_workspace(**workspace_params_with_base) do |workspace|
      workspace.send(:prepare_head_source, nil)
      info = workspace.range_git_blame_info('test/smokes/haml_lint/expectations.rb', 137, 140)
      assert_equal(
        [
          GitBlameInfo.new(commit: "839d63e3a4b0c9654a501474b5fe922d4f3f8842", original_line: 126, final_line: 137, line_hash: "c57a7c8a63aa22b9aa40625f019fe097c3a23ab8"),
          GitBlameInfo.new(commit: "998bc02a913e3899f3a1cd327e162dd54d489a4b", original_line: 138, final_line: 138, line_hash: "a77048541cecbd797666107ed16818e10cc594cb"),
          GitBlameInfo.new(commit: "998bc02a913e3899f3a1cd327e162dd54d489a4b", original_line: 139, final_line: 139, line_hash: "aa9e4a8125d41d419481f799965c6a8e98392502"),
          GitBlameInfo.new(commit: "998bc02a913e3899f3a1cd327e162dd54d489a4b", original_line: 140, final_line: 140, line_hash: "03ad52e876f71079c3e662b6d5aac4b47f33698c"),
        ], info)
    end
  end
end
