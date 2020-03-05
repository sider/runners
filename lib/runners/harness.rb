module Runners
  class Harness
    class InvalidResult < SystemError
      attr_reader :result

      def initialize(result:)
        super("Invalid result: #{result.inspect}")
        @result = result
      end
    end

    # @dynamic guid, processor_class, options, working_dir, trace_writer, warnings, ci_config
    attr_reader :guid
    attr_reader :processor_class
    attr_reader :options
    attr_reader :working_dir
    attr_reader :trace_writer
    attr_reader :warnings
    attr_reader :ci_config

    def initialize(guid:, processor_class:, options:, working_dir:, trace_writer:)
      @guid = guid
      @processor_class = processor_class
      @options = options
      @working_dir = working_dir
      @trace_writer = trace_writer
      @warnings = []
    end

    def run
      ensure_result do
        workspace = Workspace.prepare(options: options, working_dir: working_dir, trace_writer: trace_writer)
        workspace.open do |git_ssh_path, changes|

          config = Config.new(workspace.working_dir)
          @ci_config = config.content
          remove_ignored_files(config)
          begin
            instance = processor_class.new(guid: guid, workspace: workspace, config: config, git_ssh_path: git_ssh_path, trace_writer: trace_writer)

            root_dir_not_found = instance.check_root_dir_exist
            return root_dir_not_found if root_dir_not_found

            instance.push_root_dir do
              trace_writer.header "Setting up analyzer"
              instance.show_runtime_versions
              result = instance.setup do
                trace_writer.header "Running analyzer"
                instance.analyze(changes)
              end

              case result
              when Results::Success
                trace_writer.message "Removing issues from unchanged or untracked files..." do
                  result.tap do |r|
                    r.filter_issues(changes)
                    r.add_git_blame_info(workspace)
                  end
                end
              else
                result
              end
            end
          ensure
            @warnings = instance&.warnings || []
          end
        end
      end
    end

    private

    def ensure_result
      begin
        yield.tap do |result|
          unless result.valid?
            raise InvalidResult.new(result: result)
          end
        end
      rescue Config::Error => exn
        trace_writer.error <<~MSG.strip
          #{exn.message}
          ---
          #{exn.raw_content}
        MSG
        Results::Failure.new(guid: guid, message: exn.message)
      rescue UserError => exn
        Results::Failure.new(guid: guid, message: exn.message)
      rescue => exn
        Bugsnag.notify(exn)
        handle_error(exn)
        Results::Error.new(guid: guid, exception: exn)
      end
    end

    def handle_error(exn)
      case exn
      when InvalidResult
        # Do nothing because this is an internal logic error.
      else
        trace_writer.error "#{exn.message} (#{exn.class})"
      end
    end

    def remove_ignored_files(config)
      ignores = config.ignore
      return if ignores.empty?

      trace_writer.message("Deleting ignored files...") do
        with_gitignore(ignores) do |list|
          FileUtils.rm_rf(list)
          trace_writer.message list.map { |f| f.relative_path_from(working_dir) }.join("\n")
        end
      end
    end

    def with_gitignore(ignores)
      gitignore = (working_dir / ".gitignore")

      backup = gitignore.file? ? gitignore.read : nil
      gitignore.write(ignores.join("\n"))

      shell = Shell.new(current_dir: working_dir, trace_writer: trace_writer, env_hash: {})
      shell.capture3!("git", "init", trace_command_line: false, trace_stdout: false)

      # @see https://git-scm.com/docs/git-check-ignore#_exit_status
      stdout, = shell.capture3!(
        "git", "check-ignore", *working_dir.glob("**/*", File::FNM_DOTMATCH).map(&:to_s),
        trace_command_line: false,
        trace_stdout: false,
        is_success: -> (s) { s.exitstatus != 128 },
      )

      yield stdout.lines(chomp: true).map { |v| Pathname(v) }
    ensure
      FileUtils.rm_rf(working_dir / ".git") # NOTE: working_dir is not a Git directory.
      gitignore.write(backup) if backup
    end
  end
end
