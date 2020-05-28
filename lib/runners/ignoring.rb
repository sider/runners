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
      return [] if ignores.empty?

      # @type var deleted_files: Array[String]
      deleted_files = []

      trace_writer.message("Deleting ignored files...") do
        each_ignored_file do |file|
          (working_dir / file).delete
          deleted_files << file
        end
      end

      deleted_files
    end

    private

    def ignores
      config.ignore
    end

    def each_ignored_file(&block)
      Tempfile.create("gitignore-") do |file|
        gitignore = file.path
        File.write gitignore, ignores.join("\n")

        shell = Shell.new(current_dir: working_dir, trace_writer: trace_writer, env_hash: {})
        shell.capture3! "git", "init"
        shell.capture3! "git", "add", "."

        # @see https://git-scm.com/docs/git-ls-files
        stdout, = shell.capture3!(
          "git", "ls-files", "--ignored", "--exclude-from", gitignore,
          trace_command_line: true,
          trace_stdout: false,
        )
        stdout.each_line(chomp: true, &block)
      end
    end
  end
end
