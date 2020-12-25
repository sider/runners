module Runners
  class Workspace::Git < Workspace
    class Error < SystemError; end
    class FetchFailed < Error; end
    class CheckoutFailed < Error; end
    class BlameFailed < Error; end

    def range_git_blame_info(path_string, start_line, end_line, trace: false)
      @git_blame_cache ||= {}
      cache_key = :"#{path_string}\t#{start_line}\t#{end_line}"
      cache_value = @git_blame_cache[cache_key]
      return cache_value if cache_value

      stdout, _ = shell.capture3!("git", "blame", "-p", "-L", "#{start_line},#{end_line}", git_source.head, "--", path_string,
                                  trace_stdout: trace, trace_stderr: trace, trace_command_line: trace)
      GitBlameInfo.parse(stdout).tap do |result|
        @git_blame_cache[cache_key] = result
      end
    rescue Shell::ExecError => exn
      raise BlameFailed, "git-blame failed: #{exn.stderr_str}"
    end

    # TODO: This code is to investigate the issue #1865. Must remove this before release.
    def check_yarn
      shell.capture3 "yarn", "-v"
    rescue
      # noop
    end

    def prepare_head_source
      # TODO: This code is to investigate the issue #1865. Must remove this before release.
      check_yarn

      shell.capture3!("git", "init")
      shell.capture3!("git", "config", "gc.auto", "0")
      shell.capture3!("git", "config", "advice.detachedHead", "false")
      shell.capture3!("git", "config", "core.quotePath", "false")

      # TODO: This code is to investigate the issue #1865. Must remove this before release.
      check_yarn

      shell.capture3!("git", "remote", "add", "origin", remote_url)

      # TODO: This code is to investigate the issue #1865. Must remove this before release.
      check_yarn

      begin
        shell.capture3_with_retry!("git", "fetch", *git_fetch_args, tries: try_count, sleep: sleep_lambda)
      rescue Shell::ExecError => exn
        raise FetchFailed, "git-fetch failed: #{exn.stderr_str}"
      end

      # TODO: This code is to investigate the issue #1865. Must remove this before release.
      check_yarn

      begin
        shell.capture3_with_retry!("git", "checkout", git_source.head, tries: try_count)
      rescue Shell::ExecError => exn
        raise CheckoutFailed, "git-checkout failed: #{exn.stderr_str}"
      end

      # TODO: This code is to investigate the issue #1865. Must remove this before release.
      check_yarn
    end

    private

    def git_source
      options.source
    end

    # for testing
    def try_count
      10
    end

    # for testing
    def sleep_lambda
      -> (n) { Integer(n) ** 2.5 }
    end

    def remote_url
      @remote_url ||= URI.parse(git_source.git_url).then do |uri|
        git_url_userinfo = git_source.git_url_userinfo
        uri.userinfo = git_url_userinfo if git_url_userinfo
        uri.to_s.freeze
      end
    end

    def git_fetch_args
      @git_fetch_args ||= [
        '--quiet',
        '--no-tags',
        '--no-recurse-submodules',
        'origin',
        '+refs/heads/*:refs/remotes/origin/*',
        *git_source.refspec,
      ].freeze
    end

    def patches
      return @patches if defined? @patches

      base = git_source.base
      head = git_source.head

      @patches =
        if base && head
          # NOTE: We should use `...` (triple-dot) instead of `..` (double-dot). See https://git-scm.com/docs/git-diff
          stdout, _ = shell.capture3!("git", "diff", "#{base}...#{head}", trace_stdout: false)
          GitDiffParser.parse(stdout)
        end
    end
  end
end
