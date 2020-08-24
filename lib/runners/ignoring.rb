module Runners
  class Ignoring
    attr_reader :workspace, :ignore_patterns

    def initialize(workspace:, ignore_patterns:)
      @workspace = workspace
      @ignore_patterns = ignore_patterns
    end

    def delete_ignored_files!
      Tempfile.create("gitignore-") do |gitignore|
        ignore_path = gitignore.path
        File.write ignore_path, ignore_patterns.join("\n")

        # @see https://git-scm.com/docs/git-ls-files
        ignored_files, _ = workspace.shell.capture3!(
          "git", "ls-files", "--ignored", "--exclude-from", ignore_path,
          trace_stdout: false,
        )

        ignored_files.lines(chomp: true).map do |file|
          (workspace.working_dir / file).delete
          file
        end
      end
    end
  end
end
