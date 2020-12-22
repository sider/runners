require "optparse"

module Runners
  class CLI
    include Tmpdir

    attr_reader :stdout
    attr_reader :stderr
    attr_reader :guid
    attr_reader :analyzer
    attr_reader :options

    def initialize(argv:, stdout:, stderr:, options_json:)
      @stdout = stdout
      @stderr = stderr

      setup_bugsnag!(argv.dup)

      OptionParser.new do |opts|
        opts.banner = "Usage: runners [options] <GUID>"

        opts.on("--analyzer=ANALYZER", "Analyzer tool name", all_processor_classes.keys) do |analyzer|
          @analyzer = analyzer
        end
      end.parse!(argv)

      raise OptionParser::MissingArgument.new("--analyzer is required") unless analyzer

      guid = argv.shift or raise OptionParser::MissingArgument.new("GUID is required")
      @guid = guid

      @options = Options.new(options_json, stdout, stderr)
    end

    def run
      io.flush! # Write or upload empty content to let the caller of Runners notice the beginning of the analysis.
      with_working_dir do |working_dir|
        writer = JSONSEQ::Writer.new(io: io)
        trace_writer = TraceWriter.new(writer: writer, filter: SensitiveFilter.new(options: options))
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
          config_file: config&.path_name,
          version: VERSION,
        }

        trace_writer.message "Writing result..." do
          writer << Schema::Result.envelope.coerce(json)
        end

        result.tap do
          finished_at = Time.now
          trace_writer.header "Analysis finished", recorded_at: finished_at

          if result.is_a? Results::Success
            trace_writer.message "#{result.issues.size} issue(s) found."
          end

          trace_writer.message "Finished at #{finished_at.utc}"
          trace_writer.message "Elapsed time: #{format_duration(finished_at - started_at)}"
        end
      end
    ensure
      io.flush! if defined?(:@io)
    end

    private

    def setup_bugsnag!(argv)
      # NOTE: Prevent information from being stolen from environment variables.
      api_key = ENV.delete("BUGSNAG_API_KEY")
      app_version = ENV.delete("RUNNERS_VERSION")
      release_stage = ENV.delete("BUGSNAG_RELEASE_STAGE")

      # @see https://docs.bugsnag.com/platforms/ruby/configuration-options
      Bugsnag.configure do |config|
        config.api_key = api_key if api_key
        config.app_version = app_version if app_version
        config.release_stage = release_stage if release_stage

        # @see https://docs.bugsnag.com/platforms/ruby/customizing-error-reports/#adding-callbacks
        config.add_on_error(proc do |report|
          # TODO: Ignored Steep error
          # @type var report: untyped
          report.add_tab :task_guid, guid
          report.add_tab :arguments, argv
        end)
      end
    end

    def with_working_dir(&block)
      mktmpdir(&block)
    end

    def all_processor_classes
      @processor_classes ||= ObjectSpace.each_object(Class).each_with_object({}) do |cls, classes|
        next unless cls.name
        next unless cls < Processor

        # NOTE: Generate an analyzer ID from the file name convention.
        filename, _ = Module.const_source_location(cls.name)
        analyzer_id = File.basename(filename, ".rb")
        unless cls.method_defined?(:analyzer_id)
          cls.define_method(:analyzer_id) { analyzer_id }
        end

        classes[analyzer_id] = cls
      end
    end

    def processor_class
      all_processor_classes.fetch(analyzer)
    end

    def io
      @io ||= options.io
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

      res = []
      res << "#{h}h" if h.positive?
      res << "#{m}m" if m.positive?
      res << "#{s}s" if s.positive?
      res.empty? ? "0.0s" : res.join(" ")
    end
  end
end
