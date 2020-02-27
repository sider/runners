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
          begin
            instance = processor_class.new(guid: guid, workspace: workspace, config: config, git_ssh_path: git_ssh_path&.to_s, trace_writer: trace_writer)

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

    def ensure_result
      begin
        yield.tap do |result|
          unless result.valid?
            raise InvalidResult.new(result: result)
          end
        end
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
  end
end
