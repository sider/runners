module Runners
  class Harness
    include Tmpdir

    class InvalidResult < SystemError
      attr_reader :result

      def initialize(result:)
        super("Invalid result: #{result.inspect}")
        @result = result
      end
    end

    attr_reader :guid
    attr_reader :processor_class
    attr_reader :options
    attr_reader :working_dir
    attr_reader :trace_writer
    attr_reader :config
    attr_reader :analyzer

    def initialize(guid:, processor_class:, options:, working_dir:, trace_writer:)
      @guid = guid
      @processor_class = processor_class
      @options = options
      @working_dir = working_dir
      @trace_writer = trace_writer
      @analyzer = nil
    end

    def run
      ensure_result do
        workspace = Workspace.prepare(options: options, working_dir: working_dir, trace_writer: trace_writer)

        # HACK: MetricsFileInfo needs all Git blob objects to calculate code churn.
        #       This code is so ugly, but I could not find a good way.
        fast = processor_class != Processor::MetricsFileInfo

        workspace.open(fast: fast) do |git_ssh_path, changes|
          @config = conf = workspace.config

          begin
            processor = processor_class.new(guid: guid, working_dir: working_dir, config: conf,
                                            shell: build_shell(git_ssh_path), trace_writer: trace_writer, options: options)

            root_dir_not_found = processor.check_root_dir_exist
            return root_dir_not_found if root_dir_not_found

            processor.in_root_dir do
              trace_writer.header "Set up #{processor.analyzer_name}"

              processor.validate_config
              processor.check_unsupported_linters
              processor.show_runtime_versions

              result = processor.setup do
                trace_writer.header "Run #{processor.analyzer_name}"
                @analyzer = processor.analyzer # initialize analyzer
                if processor.use_git_metadata_dir?
                  processor.analyze(changes)
                else
                  exclude_special_dirs { processor.analyze(changes) }
                end
              end

              case result
              when Results::Success
                trace_writer.message "#{result.issues.size} issue(s) found."
                trace_writer.message "Removing issues from unchanged or untracked files..." do
                  result.filter_issues(changes)
                  if options.source.head && options.source.base
                    result.add_git_blame_info(workspace)
                  end
                end
                result.each_missing_id_warning { |msg| trace_writer.message(msg) }
                result
              else
                result
              end
            end
          ensure
            @warnings = processor&.warnings
          end
        end
      end
    end

    def warnings
      @warnings ||= Warnings.new
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
        trace_writer.error <<~MSG
          #{exn.message}
          ---
          #{exn.raw_content}
        MSG
        Results::Failure.new(guid: guid, message: exn.message, analyzer: analyzer)
      rescue UserError => exn
        Results::Failure.new(guid: guid, message: exn.message, analyzer: analyzer)
      rescue => exn
        Bugsnag.notify(exn) do |report|
          report.severity = "error"
        end
        handle_error(exn)
        Results::Error.new(guid: guid, exception: exn, analyzer: analyzer)
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

    def exclude_special_dirs
      saved = [".git"].filter_map do |dir|
        src = working_dir / dir
        if src.directory?
          dest = mktmpdir / dir
          src.rename(dest)
          trace_writer.message "Move #{src} to #{dest}"
          [src, dest]
        else
          trace_writer.error "#{src} is not a directory"
          nil
        end
      end.to_h

      yield
    ensure
      # restore
      saved.each do |src, dest|
        dest.rename(src)
        dest.parent.rmdir
        trace_writer.message "Restore #{dest} to #{src}"
      end
    end

    def build_shell(git_ssh_path)
      env = {
        "RUBYOPT" => nil,
        "GIT_SSH_COMMAND" => git_ssh_path&.then { |path| "ssh -F '#{path}'" },
      }
      Shell.new(current_dir: working_dir, trace_writer: trace_writer, env_hash: env)
    end
  end
end
