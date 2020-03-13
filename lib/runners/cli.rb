require "optparse"

module Runners
  class CLI
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

    def with_working_dir
      Dir.mktmpdir do |dir|
        yield Pathname(dir)
      end
    end

    def processor_class
      @processor_class ||= (Processor.subclasses.detect do |cls|
        # NOTE: Generate an analyzer ID from filename convention.
        #       This logic assumes that each subclass has its `#analyze` method.
        source_file, _ = cls.instance_method(:analyze).source_location
        analyzer_id_from_filename = File.basename(source_file, ".rb")
        unless cls.method_defined?(:analyzer_id)
          cls.define_method(:analyzer_id) { analyzer_id_from_filename }
        end

        analyzer == analyzer_id_from_filename
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
          duration = finished_at - started_at
          trace_writer.header "Analysis finished", recorded_at: finished_at
          trace_writer.message "Finished at #{finished_at.utc}"
          trace_writer.message "Elapsed time: #{format_duration(duration)}"
        end
      end
    ensure
      io.flush! if defined?(:@io)
    end

    def io
      @io ||= options.io
    end

    def sensitive_strings
      @sensitive_strings ||= [].tap do |strings|
        source = options.source
        if source.is_a?(Options::GitSource)
          # @type var source: Options::GitSource
          strings << source.git_http_userinfo if source.git_http_userinfo
        end
      end
    end

    def format_duration(duration_in_sec)
      parts = ActiveSupport::Duration.build(duration_in_sec).parts
      res = []
      parts[:hours].tap { |h| res << "#{h}h" if h && h > 0 }
      parts[:minutes].tap { |m| res << "#{m}m" if m && m > 0 }
      parts[:seconds].tap { |s| res << "#{s.round(3)}s" if s && s > 0 }
      res.empty? ? "0.0s" : res.join(" ")
    end
  end
end
