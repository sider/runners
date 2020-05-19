module Runners
  class Workspace::Git < Workspace
    def range_git_blame_info(path_string, start_line, end_line)
      stdout, _ = shell.capture3!("git", "blame", "-p", "-L", "#{start_line},#{end_line}", git_source.head, "--", path_string,
                                  trace_stdout: false, trace_stderr: true, chdir: git_directory)
      GitBlameInfo.parse(stdout)
    end

    private

    def prepare_base_source(dest)
      base = git_source.base
      if base
        provision(base, dest)
      else
        raise ArgumentError, "base must not be nil"
      end
    end

    def prepare_head_source(dest)
      provision(git_source.head, dest)
    end

    def provision(commit_hash, dest)
      shell.capture3!("git", "checkout", commit_hash, chdir: git_directory)
      FileUtils.copy_entry(git_directory, dest)
      FileUtils.remove_entry(dest / ".git")
    end

    def git_directory
      @git_directory ||= root_tmp_dir.tap do |path|
        shell.chdir(path) do
          shell.capture3!("git", "init")
          shell.capture3!("git", "config", "gc.auto", "0")
          shell.capture3!("git", "config", "advice.detachedHead", "false")
          shell.capture3!("git", "remote", "add", "origin", remote_url.to_s)
          shell.capture3!("git", "fetch", *git_fetch_args)
        end
      end
    end

    def remote_url
      @remote_url ||= URI.join(git_source.git_http_url, "#{git_source.owner}/#{git_source.repo}").tap do |uri|
        git_http_userinfo = git_source.git_http_userinfo
        uri.userinfo = git_http_userinfo if git_http_userinfo
      end
    end

    def git_fetch_args
      @git_fetch_args ||= %w[--quiet --no-tags --no-recurse-submodules origin +refs/heads/*:refs/remotes/origin/*].tap do |command|
        pull_number = git_source.pull_number
        command << "+refs/pull/#{pull_number}/head:refs/remotes/pull/#{pull_number}/head" if pull_number
      end
    end

    def patches
      base = git_source.base
      head = git_source.head
      if base && head
        # NOTE: We should use `...` (triple-dot) instead of `..` (double-dot). See https://git-scm.com/docs/git-diff
        stdout, _ = shell.capture3!("git", "diff", "#{base}...#{head}", trace_stdout: false, chdir: git_directory)
        GitDiffParser.parse(stdout)
      else
        nil
      end
    end
  end
end
