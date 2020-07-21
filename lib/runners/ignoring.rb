module Runners
  class Ignoring
    attr_reader :workspace, :ignore_patterns

    def initialize(workspace:, ignore_patterns:)
      @workspace = workspace
      @ignore_patterns = ignore_patterns
    end

    def delete_ignored_files!
      Tempfile.create("gitignore-") do |gitignore|
        File.write gitignore, ignore_patterns.join("\n")

        shell = workspace.shell
        shell.capture3! "git", "init"
        shell.capture3! "git", "add", "."

        # @see https://git-scm.com/docs/git-config#Documentation/git-config.txt-corequotePath
        shell.capture3! "git", "config", "core.quotePath", "false"

        # @see https://git-scm.com/docs/git-ls-files
        ignored_files, _ = shell.capture3!(
          "git", "ls-files", "--ignored", "--exclude-from", gitignore.path,
          trace_stdout: false,
        )

        shell.capture3! "git", "config", "--unset", "core.quotePath" # restore

        ignored_files.lines(chomp: true).map do |file|
          (workspace.working_dir / file).delete
          file
        end
      end
    end
  end
end
