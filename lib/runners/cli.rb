require "optparse"

module Runners
  class CLI
    include Tmpdir

    # @dynamic stdout, stderr, guid, analyzer, options
    attr_reader :stdout
    attr_reader :stderr
    attr_reader :guid
    attr_reader :analyzer
    attr_reader :options

    def initialize(argv:, stdout:, stderr:)
      @stdout = stdout
      @stderr = stderr

      OptionParser.new do |opts|
        opts.on("--analyzer=ANALYZER") do |analyzer|
          @analyzer = analyzer
        end
      end.parse!(argv)
      @guid = _ = argv.shift

      raise "--analyzer is required" unless analyzer
      raise "The specified analyzer is not supported" unless processor_class
      raise "GUID is required" unless guid
      @options = Options.new(stdout, stderr)
    end

    def with_working_dir(&block)
      mktmpdir(&block)
    end

    def processor_class
      @processor_class ||= (ObjectSpace.each_object(Class).filter { |cls| cls < Processor }.detect do |cls|
        # NOTE: Generate an analyzer ID from filename convention.
        #       This logic assumes that each subclass has its `#analyze` method.
        method = cls.instance_method(:analyze)
        if method
          method_loc = method.source_location
          if method_loc
            analyzer_id_from_filename = File.basename(method_loc[0], ".rb")
            unless cls.method_defined?(:analyzer_id)
              cls.define_method(:analyzer_id) { analyzer_id_from_filename }
            end
            analyzer == analyzer_id_from_filename
          end
        end
      end or raise "Not found processor class with '#{analyzer}'")
    end

    def run
      io.flush! # Write or upload empty content to let the caller of Runners notice the beginning of the analysis.
      with_working_dir do |working_dir|
        writer = JSONSEQ::Writer.new(io: io)
        trace_writer = TraceWriter.new(writer: writer, sensitive_strings: sensitive_strings)
        started_at = Time.now
        trace_writer.header "Analysis started", recorded_at: started_at
        trace_writer.message "Started at #{started_at.utc}"
        trace_writer.message "Runners version #{VERSION}"
        trace_writer.message "Build GUID #{guid}"

        harness = Harness.new(guid: guid, processor_class: processor_class, options: options, working_dir: working_dir, trace_writer: trace_writer)

        result = harness.run
        warnings = harness.warnings
        config = harness.config
        json = {
          result: result.as_json,
          warnings: warnings,
          ci_config: config&.content,
          version: VERSION,
        }

        trace_writer.message "Writing result..." do
          writer << Schema::Result.envelope.coerce(json)
        end

        result.tap do
          finished_at = Time.now
          trace_writer.header "Analysis finished", recorded_at: finished_at

          if result.is_a? Results::Success
            # @type var result: Results::Success
            trace_writer.message "#{result.issues.size} issue(s) found."
          end

          trace_writer.message "Finished at #{finished_at.utc}"
          trace_writer.message "Elapsed time: #{format_duration(finished_at - started_at)}"
        end
      end
    ensure
      io.flush! if defined?(:@io)
    end

    def io
      @io ||= options.io
    end

    def sensitive_strings
      @sensitive_strings ||= begin
        # @type var strings: Array[String]
        strings = []
        source = options.source
        if source.is_a?(Options::GitSource)
          # @type var source: Options::GitSource
          user_info = source.git_http_userinfo
          strings << user_info if user_info
        end
        strings
      end
    end

    def format_duration(duration_in_sec)
      value = duration_in_sec

      seconds_per_hour = 3600.0
      h = value.div(seconds_per_hour)
      value -= h * seconds_per_hour

      seconds_per_minute = 60.0
      m = value.div(seconds_per_minute)
      value -= m * seconds_per_minute

      s = value.round(value.to_i == 0 ? 3 : 0)

      # @type var res: Array[String]
      res = []
      res << "#{h}h" if h.positive?
      res << "#{m}m" if m.positive?
      res << "#{s}s" if s.positive?
      res.empty? ? "0.0s" : res.join(" ")
    end
  end
end
