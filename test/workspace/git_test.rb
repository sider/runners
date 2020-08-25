require "test_helper"

class WorkspaceGitTest < Minitest::Test
  include TestHelper

  GitBlameInfo = Runners::GitBlameInfo

  def with_workspace(**params)
    super(**params) do |workspace|
      workspace.stub :try_count, 1 do
        workspace.stub :sleep_lambda, lambda { 0 } do
          yield workspace
        end
      end
    end
  end

  def test_instance_class
    with_workspace do |workspace|
      assert_instance_of Runners::Workspace::Git, workspace
    end
  end

  def test_prepare_head_source
    with_workspace do |workspace|
      workspace.prepare_head_source

      dest = workspace.working_dir
      refute_empty dest.children
      assert_path_exists dest / "README.md"
      assert_path_exists dest / ".git"
    end
  end

  def test_remote_url
    with_workspace do |workspace|
      assert_equal URI("https://github.com/sider/runners_test"), workspace.send(:remote_url)
    end
  end

  def test_remote_url_with_file
    with_workspace(git_url: 'file:///project/smoke/foo/bar') do |workspace|
      assert_equal URI("file:///project/smoke/foo/bar"), workspace.send(:remote_url)
    end
  end

  def test_remote_url_with_token
    with_workspace(git_url_userinfo: "x-access-token:v1.aaabbbcccdddeeefffgggbc06400127f248a82ac") do |workspace|
      assert_equal URI("https://x-access-token:v1.aaabbbcccdddeeefffgggbc06400127f248a82ac@github.com/sider/runners_test"), workspace.send(:remote_url)
    end
  end

  def test_git_fetch_args
    with_workspace(refspec: "+refs/pull/533/head:refs/remotes/pull/533/head") do |workspace|
      assert_equal %w[
        --quiet --no-tags --no-recurse-submodules origin
        +refs/heads/*:refs/remotes/origin/*
        +refs/pull/533/head:refs/remotes/pull/533/head
      ], workspace.send(:git_fetch_args)
    end
  end

  def test_git_fetch_args_with_multiple_refspecs
    with_workspace(refspec: ["+refs/pull/533/head:refs/remotes/pull/533/head", "+refs/foo/533/head:refs/remotes/foo/533/head"]) do |workspace|
      assert_equal %w[
        --quiet --no-tags --no-recurse-submodules origin
        +refs/heads/*:refs/remotes/origin/*
        +refs/pull/533/head:refs/remotes/pull/533/head
        +refs/foo/533/head:refs/remotes/foo/533/head
      ], workspace.send(:git_fetch_args)
    end
  end

  def test_git_fetch_args_without_refspaces
    with_workspace do |workspace|
      assert_equal %w[
        --quiet --no-tags --no-recurse-submodules origin
        +refs/heads/*:refs/remotes/origin/*
      ], workspace.send(:git_fetch_args)
    end
  end

  def test_patches_returns_nil
    with_workspace(base: nil) do |workspace|
      assert_nil workspace.send(:patches)
    end
  end

  def test_patches
    with_workspace(head: "836880fdd04e5e1d7d82ed17dae838a16cfa50b2", base: base_commit) do |workspace|
      workspace.prepare_head_source
      patches = workspace.send(:patches)
      assert_equal ["README.md", "sider.yml", "てすと.txt"], patches.files
    end
  end

  def test_patches_not_calling_git_diff_twice
    with_workspace(base: base_commit) do |workspace|
      workspace.prepare_head_source
      p1 = workspace.send(:patches)
      p2 = workspace.send(:patches)
      assert_same p1, p2
      assert_equal 1, workspace.trace_writer.writer.count { |e| e[:command_line]&.slice(0, 2) == %w[git diff] }
    end
  end

  def test_git_blame_info
    with_workspace(head: "330716dcd50a7a2c7d8ff79d74035c05453528b4", base: "cd33ab59ef3d75e54e6d49c000bc8f141d94d356") do |workspace|
      workspace.prepare_head_source
      actual = workspace.range_git_blame_info("README.md", 1, 2)
      expected = [
        GitBlameInfo.new(commit: "cd33ab59ef3d75e54e6d49c000bc8f141d94d356", original_line: 1, final_line: 1, line_hash: "82c89d4ea306d31642e44c10609b686671e485dc"),
        GitBlameInfo.new(commit: "330716dcd50a7a2c7d8ff79d74035c05453528b4", original_line: 2, final_line: 2, line_hash: "da39a3ee5e6b4b0d3255bfef95601890afd80709"),
      ]
      assert_equal expected, actual

      # Using cache
      actual = workspace.range_git_blame_info("README.md", 1, 2)
      assert_equal expected, actual
      assert_equal 1, workspace.trace_writer.writer.count { _1[:command_line]&.slice(0, 2) == %w[git blame] }
    end
  end

  def test_git_blame_info_failed
    with_workspace do |workspace|
      workspace.prepare_head_source
      (workspace.working_dir / ".git").rmtree

      error = assert_raises(Runners::Workspace::Git::BlameFailed) do
        workspace.range_git_blame_info('test/smokes/haml_lint/expectations.rb', 137, 140)
      end
      assert_match %r{\Agit-blame failed: fatal: not a git repository \(or any of the parent directories\): \.git}, error.message
    end
  end

  def test_git_fetch_failed
    with_workspace(refspec: "+refs/pull/999999999/head:refs/remotes/pull/999999999/head") do |workspace|
      error = assert_raises(Runners::Workspace::Git::FetchFailed) do
        workspace.prepare_head_source
      end
      assert_match %r{\Agit-fetch failed: fatal: couldn't find remote ref refs/pull/999999999/head}, error.message
    end
  end

  def test_git_checkout_failed
    with_workspace(head: "invalid_commit") do |workspace|
      error = assert_raises(Runners::Workspace::Git::CheckoutFailed) do
        workspace.prepare_head_source
      end
      assert_match %r{\Agit-checkout failed: error: pathspec 'invalid_commit' did not match any file\(s\) known to git}, error.message
    end
  end
end
