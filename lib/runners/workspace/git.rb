module Runners
  class Workspace::Git < Workspace
    class Error < SystemError; end
    class CloneFailed < Error; end
    class FetchFailed < Error; end
    class CheckoutFailed < Error; end
    class SparseCheckoutFailed < Error; end
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

    def prepare_head_source
      git_clone
      git_setup

      # Fetch a pull request if specified (including a forked repository).
      git_fetch(git_source.refspec) unless git_source.refspec.empty?

      # First, fetch only a configuration file.
      git_sparse_checkout_set "/#{Config::FILE_NAME}", "/#{Config::FILE_NAME_OLD}"
      git_checkout

      # Next, fetch remaining files except for *ignored* files.
      patterns = processor_class.metrics? ? config.metrics_ignore_patterns : []
      patterns += config.ignore_patterns
      git_sparse_checkout_set "/**", *Config.invert_patterns(patterns)
      git_checkout
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

    # @see https://git-scm.com/docs/git-config
    def git_setup
      shell.capture3!("git", "config", "gc.auto", "0")
      shell.capture3!("git", "config", "advice.detachedHead", "false")
      shell.capture3!("git", "config", "core.quotePath", "false")
      shell.capture3!("git", "config", "core.hooksPath", mktmpdir.to_path) # NOTE: Prevent evil hooks from being executed.
    end

    # @see https://git-scm.com/docs/git-clone
    # @see https://git-scm.com/docs/partial-clone
    def git_clone
      options = %w[
        --no-checkout
        --no-recurse-submodules
        --no-tags
        --quiet
      ]

      # NOTE: MetricsFileInfo needs all Git blob objects to calculate code churn.
      if processor_class != Processor::MetricsFileInfo
        options << "--filter=blob:none"
      end

      shell.capture3_with_retry!("git", "clone", *options, "--", remote_url, ".", tries: try_count, sleep: sleep_lambda)
    rescue Shell::ExecError => exn
      raise CloneFailed, "git-clone failed: #{exn.stderr_str}"
    end

    # @see https://git-scm.com/docs/git-fetch
    def git_fetch(refspec)
      shell.capture3_with_retry!("git", "fetch", "origin", *refspec, tries: try_count, sleep: sleep_lambda)
    rescue Shell::ExecError => exn
      raise FetchFailed, "git-fetch failed: #{exn.stderr_str}"
    end

    # @see https://git-scm.com/docs/git-checkout
    def git_checkout
      shell.capture3_with_retry!("git", "checkout", git_source.head, tries: try_count)
    rescue Shell::ExecError => exn
      raise CheckoutFailed, "git-checkout failed: #{exn.stderr_str}"
    end

    # @see https://git-scm.com/docs/git-sparse-checkout
    # @see https://git-scm.com/docs/gitignore
    def git_sparse_checkout_set(*patterns)
      shell.capture3!("git", "sparse-checkout", "set", *patterns)
    rescue Shell::ExecError => exn
      raise SparseCheckoutFailed, "git-sparse-checkout failed: #{exn.stderr_str}"
    end
  end
end
