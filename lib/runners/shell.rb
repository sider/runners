module Runners
  class Shell
    class ExecError < SystemError
      # @dynamic type, args, stdout_str, stderr_str, status, dir
      attr_reader :type
      attr_reader :args
      attr_reader :stdout_str
      attr_reader :stderr_str
      attr_reader :status
      attr_reader :dir

      def initialize(type:, args:, stdout_str:, stderr_str:, status:, dir:)
        super("Command [#{args.join(' ')}] exited with #{status.exitstatus.inspect}")
        @type = type
        @args = args
        @stdout_str = stdout_str
        @stderr_str = stderr_str
        @status = status
        @dir = dir
      end

      def inspect
        "#<#{self.class.name}: type=#{type}, args=#{args.inspect}, status=#{status.inspect}, dir=#{dir.inspect}, stdout_str=..., stderr_str=...>"
      end

      # @see https://docs.bugsnag.com/platforms/ruby/customizing-error-reports/#custom-error-diagnostic-data
      def bugsnag_meta_data
        {
          details: {
            args: args,
            stdout: stdout_str,
            stderr: stderr_str,
            status: status.exitstatus,
          }
        }
      end
    end

    # @dynamic trace_writer, dir_stack, env_hash_stack
    attr_reader :trace_writer
    attr_reader :dir_stack
    attr_reader :env_hash_stack

    def initialize(current_dir:, trace_writer:, env_hash:)
      @trace_writer = trace_writer
      @dir_stack = [current_dir]
      @env_hash_stack = [env_hash]
    end

    def current_dir
      dir_stack.last or raise "Empty dir stack"
    end

    def push_dir(dir)
      dir_stack.push dir
      yield
    ensure
      dir_stack.pop
    end

    def push_env_hash(env)
      env_hash_stack.push(env)
      yield
    ensure
      env_hash_stack.pop
    end

    def env_hash
      env_hash_stack.inject({}) do |acc, env|
        # @type var acc: Hash[String, String?]
        acc.merge(env)
      end
    end

    def capture3(command, *args, **options)
      capture3_trace(command, *args, **options)
    end

    def capture3!(command, *args, **options)
      stdout, stderr, = capture3_trace(command, *args, **options.merge(raise_on_failure: true))
      [stdout, stderr]
    end

    def capture3_with_retry!(command, *args, tries: 3)
      Retryable.retryable(
        tries: tries,
        on: ExecError,
        sleep: -> (n) { n + 1 },
        exception_cb: -> (_ex) { trace_writer.message "Command failed. Retrying..." }
      ) do
        capture3!(command, *args)
      end
    end

    # TODO: After migrating to Steep (>= 0.14), use keyword arguments like `trace_stdout: true, ...`
    def capture3_trace(command, *args, **options)
      # @type var options: untyped
      trace_stdout = options.fetch(:trace_stdout, true)
      trace_stderr = options.fetch(:trace_stderr, true)
      trace_command_line = options.fetch(:trace_command_line, true)
      raise_on_failure = options.fetch(:raise_on_failure, false)
      chdir = options[:chdir] || current_dir
      is_success = options.fetch(:is_success) { ->(status) { status.success? } }

      command_line = [command] + args
      trace_writer.command_line(command_line) if trace_command_line

      Open3.capture3(env_hash, command, *args, { chdir: chdir.to_s }).tap do |stdout_str, stderr_str, status|
        trace_writer.stdout stdout_str if trace_stdout
        trace_writer.stderr stderr_str if trace_stderr

        if status.exited?
          trace_writer.status status if trace_command_line
        else
          trace_writer.error "Process aborted or coredumped: #{status.inspect}"
        end

        unless is_success.call(status)
          if raise_on_failure
            raise ExecError.new(type: :capture3,
                                args: command_line,
                                stdout_str: stdout_str,
                                stderr_str: stderr_str,
                                status: status,
                                dir: current_dir)
          end
        end
      end
    end
  end
end
