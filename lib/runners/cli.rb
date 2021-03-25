require "optparse"

module Runners
  class CLI
    DEFAULT_WORKING_DIR = (Pathname(Dir.home) / "project").freeze
    private_constant :DEFAULT_WORKING_DIR

    attr_reader :stdout
    attr_reader :stderr
    attr_reader :guid
    attr_reader :analyzer
    attr_reader :options
    attr_reader :working_dir

    def initialize(argv:, stdout:, stderr:, options_json:, working_dir: DEFAULT_WORKING_DIR)
      @stdout = stdout
      @stderr = stderr

      setup_bugsnag!(argv.dup)
      setup_aws!

      option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: runners [options] <GUID>"

        opts.on("--analyzer=ANALYZER", "Analyzer name", Processor.children.keys) do |analyzer|
          @analyzer = analyzer.to_sym
        end
      end

      begin
        option_parser.parse!(argv)
      rescue OptionParser::ParseError
        option_parser.abort
      end

      @analyzer or abort option_parser.help

      guid = argv.shift
      if guid
        @guid = guid
      else
        option_parser.abort "missing GUID"
      end

      @options = Options.new(options_json, stdout, stderr)

      if working_dir.exist?
        raise ArgumentError, "`#{working_dir}` must not exist"
      else
        working_dir.mkdir
        @working_dir = working_dir
      end
    end

    def run
      io.flush! # Write or upload empty content to let the caller of Runners notice the beginning of the analysis.

      writer = JSONSEQ::Writer.new(io: io)
      trace_writer = TraceWriter.new(writer: writer, filter: SensitiveFilter.new(options: options))
      started_at = Time.now
      trace_writer.header "Start analysis", recorded_at: started_at
      trace_writer.message "Started at #{started_at.utc}"
      trace_writer.message "Runners version #{VERSION}"
      trace_writer.message "Build GUID #{guid}"

      harness = Harness.new(guid: guid, processor_class: processor_class, options: options,
                            working_dir: working_dir, trace_writer: trace_writer)

      result = harness.run
      warnings = harness.warnings
      config = harness.config
      json = {
        result: result.as_json,
        warnings: warnings.as_json,
        ci_config: config&.content,
        config_file: config&.path_name,
        version: VERSION,
      }

      trace_writer.message "Writing result..." do
        writer << Schema::Result.envelope.coerce(json)
      end

      result.tap do
        finished_at = Time.now
        trace_writer.header "Finish analysis"
        trace_writer.message finish_message(result, warnings)
        trace_writer.message "Finished at #{finished_at.utc}"
        trace_writer.message "Elapsed time: #{format_duration(finished_at - started_at)}"
        trace_writer.finish started_at: started_at, finished_at: finished_at
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
          report.add_tab :task_guid, guid
          report.add_tab :arguments, argv
        end)
      end
    end

    def setup_aws!
      # NOTE: Prevent information from being stolen from environment variables.
      id = ENV.delete("AWS_ACCESS_KEY_ID")
      secret = ENV.delete("AWS_SECRET_ACCESS_KEY")
      region = ENV.delete("AWS_REGION")

      # @see https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html
      Aws.config[:credentials] = Aws::Credentials.new(id, secret) if id && secret
      Aws.config[:region] = region if region
    end

    def processor_class
      Processor.children.fetch(analyzer)
    end

    def io
      @io ||= options.io
    end

    def finish_message(result, warnings)
      analyzer_name = result.analyzer&.name

      case result
      when Results::Success
        "#{analyzer_name} analysis succeeded: #{result.issues.size} issues, #{warnings.size} warnings"
      else
        analyzer_name ? "#{analyzer_name} analysis failed." : "Analysis failed."
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

      res = []
      res << "#{h}h" if h.positive?
      res << "#{m}m" if m.positive?
      res << "#{s}s" if s.positive?
      res.empty? ? "0.0s" : res.join(" ")
    end
  end
end
