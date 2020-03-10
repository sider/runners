module Runners
  class TraceWriter
    attr_reader :writer, :sensitive_strings

    def initialize(writer:, sensitive_strings: [])
      @writer = writer
      @sensitive_strings = sensitive_strings
    end

    def command_line(command_line, recorded_at: now)
      self << { trace: :command_line, command_line: command_line.map { |v| masked_string(v) }, recorded_at: recorded_at }
    end

    def status(status, recorded_at: now)
      self << { trace: :status, status: status.exitstatus, recorded_at: recorded_at }
    end

    def stdout(string, recorded_at: now, max_length: 4_000)
      string = string.strip
      return if string.empty?

      each_slice(masked_string(string), size: max_length) do |text, truncated|
        self << { trace: :stdout, string: text, recorded_at: recorded_at, truncated: truncated }
      end
    end

    def stderr(string, recorded_at: now, max_length: 4_000)
      string = string.strip
      return if string.empty?

      each_slice(masked_string(string), size: max_length) do |text, truncated|
        self << { trace: :stderr, string: text, recorded_at: recorded_at, truncated: truncated }
      end
    end

    def message(message, recorded_at: now, max_length: 4_000, limit: 40_000, omission: "...(truncated)")
      string = masked_string(message.strip)

      if string.size > limit
        string = string[0, limit] + omission
        all_truncated = true
      end

      block_given = block_given?
      each_slice(string, size: max_length) do |text, truncated|
        self << { trace: :message, message: text, recorded_at: recorded_at, truncated: all_truncated || truncated }.tap do |entry|
          entry[:duration_in_ms] = 0 if block_given
        end
      end

      if block_given
        start = now
        yield.tap do
          duration = now - start
          duration_in_ms = (duration * 1000).truncate
          duration_in_ms = 1 if duration_in_ms == 0 # NOTE: Prevent zero (no time)
          self << { trace: :message, message: "-> #{duration_in_ms / 1000.0}s", recorded_at: recorded_at + duration,
                    truncated: false, duration_in_ms: duration_in_ms }
        end
      end
    end

    def header(message, recorded_at: now)
      self << { trace: :header, message: masked_string(message.strip), recorded_at: recorded_at }
    end

    def warning(message, file: nil, recorded_at: now)
      self << { trace: :warning, file: file, message: masked_string(message.strip), recorded_at: recorded_at }
    end

    def ci_config(content, raw_content:, file:, recorded_at: now)
      self << { trace: :ci_config, content: content, raw_content: raw_content, file: file, recorded_at: recorded_at }
    end

    def error(message, recorded_at: now, max_length: 4_000)
      each_slice(masked_string(message.strip), size: max_length) do |text, truncated|
        self << { trace: :error, message: text, recorded_at: recorded_at, truncated: truncated }
      end
    end

    def <<(object)
      recorded_at = object[:recorded_at]
      object = object.merge(recorded_at: recorded_at.utc.iso8601(3)) if recorded_at
      writer << Schema::Trace.anything.coerce(object)
    end

    private

    def now
      Time.now
    end

    def each_slice(string, size:)
      string = string.dup

      while string.length > 0
        slice = string.slice!(0, size)
        truncated = slice.length == size
        yield slice, truncated
      end
    end

    def masked_string(str)
      sensitive_strings.inject(str) do |ret, secure_string|
        ret.gsub(secure_string, "[FILTERED]")
      end
    end
  end
end
