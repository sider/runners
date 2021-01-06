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
    attr_reader :warnings
    attr_reader :config

    def initialize(guid:, processor_class:, options:, working_dir:, trace_writer:)
      @guid = guid
      @processor_class = processor_class
      @options = options
      @working_dir = working_dir
      @trace_writer = trace_writer
      @warnings = []
      @analyzer = nil
    end

    def run
      ensure_result do
        workspace = Workspace.prepare(options: options, working_dir: working_dir, trace_writer: trace_writer)
        workspace.open do |git_ssh_path, changes|
          @config = conf = Config.load_from_dir(workspace.working_dir)

          unless conf.ignore_patterns.empty?
            trace_writer.message "Deleting ignored files..." do
              files = Ignoring.new(workspace: workspace, ignore_patterns: conf.ignore_patterns).delete_ignored_files!
              trace_writer.message(files.empty? ? "No deleted files." : "Successfully deleted #{files.size} file(s)")
            end
          end

          begin
            processor = processor_class.new(guid: guid, working_dir: working_dir, config: conf, git_ssh_path: git_ssh_path, trace_writer: trace_writer)

            root_dir_not_found = processor.check_root_dir_exist
            return root_dir_not_found if root_dir_not_found

            processor.in_root_dir do
              trace_writer.header "Set up #{processor.analyzer_name}"
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
            @warnings = processor&.warnings || []
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
        trace_writer.error <<~MSG
          #{exn.message}
          ---
          #{exn.raw_content}
        MSG
        Results::Failure.new(guid: guid, message: exn.message, analyzer: @analyzer)
      rescue UserError => exn
        Results::Failure.new(guid: guid, message: exn.message, analyzer: @analyzer)
      rescue => exn
        Bugsnag.notify(exn) do |report|
          report.severity = "error"
        end
        handle_error(exn)
        Results::Error.new(guid: guid, exception: exn, analyzer: @analyzer)
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
  end
end
