module Runners
  class Ignoring
    # @dynamic working_dir, trace_writer, config
    attr_reader :working_dir, :trace_writer, :config

    def initialize(working_dir:, trace_writer:, config:)
      @working_dir = working_dir
      @trace_writer = trace_writer
      @config = config
    end

    def delete_ignored_files!
      return if ignores.empty?

      trace_writer.message("Deleting ignored files...") do
        with_gitignore do |list|
          FileUtils.rm_rf list
          trace_writer.message list.map { |f| f.relative_path_from(working_dir).to_path }.sort.join("\n")
        end
      end
    end

    private

    def ignores
      config.ignore
    end

    def with_gitignore
      gitignore = (working_dir / ".gitignore")

      backup = gitignore.file? ? gitignore.read : nil
      gitignore.write(ignores.join("\n"))

      all_files = working_dir.glob("**/*", File::FNM_DOTMATCH).filter(&:file?).map(&:to_path)

      shell = Shell.new(current_dir: working_dir, trace_writer: trace_writer, env_hash: {})
      shell.capture3!("git", "init", trace_command_line: true, trace_stdout: true)

      # @see https://git-scm.com/docs/git-check-ignore#_exit_status
      stdout, = shell.capture3!(
        "git", "check-ignore", "--stdin", "-z",
        trace_command_line: true,
        trace_stdout: false,
        is_success: -> (s) { s.exitstatus != 128 },
        stdin_data: all_files.join("\0"),
      )

      yield stdout.split("\0").map { |f| Pathname(f) }
    ensure
      FileUtils.rm_rf(working_dir / ".git") # NOTE: working_dir is not a Git directory.
      gitignore.write(backup) if backup
    end
  end
end
