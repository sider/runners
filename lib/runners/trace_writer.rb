module Runners
  class TraceWriter
    attr_reader :writer, :filter

    def initialize(writer:, filter:)
      @writer = writer
      @filter = filter
    end

    def command_line(command_line, recorded_at: now)
      self << { trace: :command_line, command_line: command_line.map { |v| filter.mask(v) }, recorded_at: recorded_at }
    end

    def status(status, recorded_at: now)
      self << { trace: :status, status: status.exitstatus, recorded_at: recorded_at }
    end

    def stdout(string, recorded_at: now, max_length: 4_000)
      return unless string

      string = string.strip
      return if string.empty?

      each_slice(filter.mask(string), size: max_length) do |text, truncated|
        self << { trace: :stdout, string: text, recorded_at: recorded_at, truncated: truncated }
      end
    end

    def stderr(string, recorded_at: now, max_length: 4_000)
      return unless string

      string = string.strip
      return if string.empty?

      each_slice(filter.mask(string), size: max_length) do |text, truncated|
        self << { trace: :stderr, string: text, recorded_at: recorded_at, truncated: truncated }
      end
    end

    def message(message, recorded_at: now, max_length: 4_000, limit: 100_000, omission: "...(truncated)")
      string = filter.mask(message.strip)

      if string.size > limit
        string = string[0, limit].to_s + omission
        all_truncated = true
      end

      block_given = block_given?
      each_slice(string, size: max_length) do |text, truncated|
        self << { trace: :message, message: text, recorded_at: recorded_at,
                  truncated: all_truncated || truncated,
                  duration_in_ms: block_given ? 0 : nil }.compact
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
      self << { trace: :header, message: filter.mask(message.strip), recorded_at: recorded_at }
    end

    def warning(message, file: nil, recorded_at: now)
      self << { trace: :warning, file: file, message: filter.mask(message.strip), recorded_at: recorded_at }
    end

    def ci_config(content, raw_content:, file:, recorded_at: now)
      self << { trace: :ci_config, content: content, raw_content: raw_content, file: file, recorded_at: recorded_at }
    end

    def error(message, recorded_at: now, max_length: 4_000)
      each_slice(filter.mask(message.strip), size: max_length) do |text, truncated|
        self << { trace: :error, message: text, recorded_at: recorded_at, truncated: truncated }
      end
    end

    def finish(started_at:, finished_at:, recorded_at: now)
      duration_in_sec = Integer(finished_at - started_at)
      started_at = started_at.utc.iso8601(3)
      finished_at = finished_at.utc.iso8601(3)
      self << { trace: :finish, duration_in_sec: duration_in_sec, started_at: started_at, finished_at: finished_at, recorded_at: recorded_at }
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
        slice = string.slice!(0, size) or raise "Invalid sliced string: string=#{string.inspect}, size=#{size.inspect}"
        truncated = slice.length == size
        yield slice, truncated
      end
    end
  end
end
