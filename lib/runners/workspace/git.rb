module Runners
  class Workspace::Git < Workspace
    def range_git_blame_info(path_string, start_line, end_line)
      shell = Shell.new(current_dir: git_directory, trace_writer: trace_writer, env_hash: {})
      stdout, _ = shell.capture3!("git", "blame", "-p", "-L", "#{start_line},#{end_line}", git_source.head, "--", path_string, trace_stdout: false, trace_stderr: true)
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
      shell = Shell.new(current_dir: git_directory, trace_writer: trace_writer, env_hash: {})
      shell.capture3!("git", "checkout", commit_hash)
      FileUtils.copy_entry(git_directory, dest)
      FileUtils.remove_entry(dest / ".git")
    end

    def git_directory
      @git_directory ||= root_tmp_dir.tap do |path|
        shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})
        shell.capture3!("git", "init")
        shell.capture3!("git", "config", "gc.auto", "0")
        shell.capture3!("git", "remote", "add", "origin", remote_url.to_s)
        shell.capture3!("git", "fetch", *git_fetch_args)
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
        git_directory.yield_self do |path|
          shell = Shell.new(current_dir: path, trace_writer: trace_writer, env_hash: {})
          stdout, _ = shell.capture3!("git", "diff", base, head, trace_stdout: false)
          GitDiffParser.parse(stdout)
        end
      else
        nil
      end
    end
  end
end
