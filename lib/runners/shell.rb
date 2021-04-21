module Runners
  class Shell
    class ExecError < SystemError
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
            status: status.inspect,
            exitstatus: status.exitstatus,
            stopsig: status.stopsig,
            termsig: status.termsig,
          }
        }
      end
    end

    attr_reader :trace_writer
    attr_reader :current_dir
    attr_reader :env_hash_stack

    # signal number for analyse timeout
    SIGUSR2 = Signal.list.fetch('USR2')

    def initialize(current_dir:, trace_writer:, env_hash: {})
      @trace_writer = trace_writer
      @current_dir = current_dir
      @env_hash_stack = [env_hash]
    end

    def chdir(dir)
      backup = @current_dir
      Dir.chdir(dir.to_s) do |path|
        @current_dir = Pathname(path)
        yield @current_dir
      end
    ensure
      @current_dir = backup
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

    def capture3_with_retry!(command, *args, tries: 3, sleep: -> (n) { Integer(n) + 1 })
      Retryable.retryable(
        tries: tries,
        on: ExecError,
        sleep: sleep,
        exception_cb: -> (_ex) { trace_writer.message "Command failed. Retrying..." }
      ) do
        capture3!(command, *args)
      end or raise "Unexpected result (tries=#{tries}): #{command} #{args.join(' ')}"
    end

    def capture3_trace(command, *args,
                       trace_stdout: true, trace_stderr: true, trace_command_line: true,
                       raise_on_failure: false, chdir: nil,
                       is_success: ->(status) { status.success? },
                       stdin_data: nil, merge_output: false)
      chdir ||= current_dir
      new_args = args.map { |arg| arg.is_a?(Pathname) ? arg.to_path : arg }
      command_line = [command] + new_args

      trace_writer.command_line(command_line) if trace_command_line

      method = merge_output ? :capture2e : :capture3
      Open3.public_send(method, env_hash, command, *new_args, chdir: chdir, stdin_data: stdin_data).then do |stdout_str, stderr_str, status|
        if merge_output
          status = stderr_str
          stderr_str = ""
        end

        trace_writer.stdout stdout_str if trace_stdout
        trace_writer.stderr stderr_str if trace_stderr

        if status.exited?
          # normal case
          trace_writer.status status if trace_command_line
        elsif status.termsig == SIGUSR2
          # timeout
          trace_writer.error "Analysis timeout (#{ENV.fetch('RUNNERS_TIMEOUT')})"
        else
          # other failure
          trace_writer.error "Process aborted or coredumped: #{status.inspect}"
        end

        unless is_success.call(status)
          if raise_on_failure
            raise ExecError.new(type: method,
                                args: command_line,
                                stdout_str: trace_writer.filter.mask(stdout_str),
                                stderr_str: trace_writer.filter.mask(stderr_str),
                                status: status,
                                dir: chdir)
          end
        end

        [stdout_str, stderr_str, status]
      end
    end
  end
end
