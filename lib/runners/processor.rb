module Runners
  class Processor
    extend Forwardable

    def self.analyzer_id
      # Naming convention
      source_file, _ = Module.const_source_location(name.to_s)
      File.basename(source_file, ".rb").to_sym
    end

    def self.children
      @children ||= ObjectSpace.each_object(Class)
        .filter { |cls| cls.name && cls < self }
        .to_h { |cls| [cls.analyzer_id, cls] }
        .freeze
    end

    def self.register_config_schema(schema)
      Schema::Config.register(name: analyzer_id, schema: schema)
    end

    def self.config_example
      raise NotImplementedError, "#{name} needs to implement `.#{__method__}`"
    end

    attr_reader :guid, :working_dir, :config, :shell, :trace_writer, :warnings, :options

    def_delegators :@shell,
      :chdir, :current_dir,
      :capture3, :capture3!, :capture3_trace, :capture3_with_retry!,
      :env_hash, :push_env_hash

    def initialize(guid:, working_dir:, config:, shell:, trace_writer:, options: nil)
      @guid = guid
      @working_dir = working_dir
      @config = config
      @shell = shell
      @trace_writer = trace_writer
      @warnings = Warnings.new(trace_writer: trace_writer)
      @options = options
    end

    def validate_config
      if config.path_exist?
        trace_writer.ci_config(config.content, raw_content: config.raw_content!, file: config.path_name)

        config.validate
        config.warnings.each { |w| add_warning(w.fetch(:message).to_s, file: w.fetch(:file)) }
      end
    end

    def relative_path(original, from: working_dir)
      path = Pathname(original)
      if path.relative?
        path = (current_dir / path).cleanpath
      end

      path.relative_path_from(from)
    end

    def check_unsupported_linters
      # TODO: Keep the following schemas for the backward compatibility.
      message = config.check_unsupported_linters ["golint", "go_vet", "gometalinter"]
      unless message.empty?
        add_warning message, file: config.path_name
      end
    end

    def setup
      trace_writer.message "No setup..."
      yield
    end

    def analyze(changes)
      raise NotImplementedError, "No implementation: #{self.class}#analyze"
    end

    def analyzers
      @analyzers ||= Analyzers.new
    end

    def analyzer_id
      @analyzer_id ||= self.class.analyzer_id
    end

    def analyzer_name
      analyzers.name(analyzer_id)
    end

    def analyzer_doc
      analyzers.doc(analyzer_id)
    end

    def analyzer_github(id = analyzer_id)
      analyzers.github(id) or raise "`#{id}` has no GitHub URL"
    end

    def analyzer
      @analyzer ||= Analyzer.new(name: analyzer_name, version: analyzer_version)
    end

    def analyzer_bin
      analyzer_id.to_s
    end

    def default_analyzer_version
      @default_analyzer_version ||= extract_version! analyzer_bin
    end

    def analyzer_version
      default_analyzer_version
    end

    def extract_version_option
      "--version"
    end

    def extract_version!(command, version_option = extract_version_option, pattern: /v?(\d+\.\d+(\.\d+)?)\b/)
      command_line = Array(command) + Array(version_option)
      cmd = command_line.first or raise ArgumentError, "Unspecified command"
      cmd_opts = command_line.drop(1).tap do |opts|
        raise ArgumentError, "Unspecified command: `#{command_line.inspect}`" if opts.empty?
      end
      outputs = capture3!(cmd, *cmd_opts)
      outputs.each do |output|
        pattern.match(output) do |match|
          found = match[1]
          return found if found
        end
      end
      raise ArgumentError, "Not found version from the command `#{command_line.join(' ')}`"
    end

    # If a processor needs git metadata('.git' dir), override this method as returning true.
    def use_git_metadata_dir?
      false
    end

    def config_linter
      config.linter(analyzer_id)
    end

    def check_root_dir_exist
      return if root_dir.directory?

      message = "`#{relative_path(root_dir)}` directory is not found! Please check `#{config_field_path(:root_dir)}` in your `#{config.path_name}`"
      trace_writer.error message
      Results::Failure.new(guid: guid, message: message)
    end

    def in_root_dir(&block)
      chdir(root_dir, &block)
    end

    def root_dir
      config_linter[:root_dir]&.yield_self { |root| working_dir / root } || working_dir
    end

    def missing_config_file_result(file)
      add_warning <<~MSG, file: file
        Sider could not find the required configuration file `#{file}`.
        Please create the file according to the document:
        #{analyzer_doc}
      MSG

      Results::Success.new(guid: guid, analyzer: analyzer)
    end

    def config_field_path(*fields)
      config.linter_field_path(analyzer_id, *fields)
    end

    def delete_unchanged_files(changes, except: [], only: [])
      return if changes.unchanged_paths.empty?

      trace_writer.message "Deleting unchanged files from working copy..." do
        files = changes.delete_unchanged(dir: working_dir, except: except, only: only)
        trace_writer.message files.join("\n")
      end
    end

    def add_warning(message, file: nil)
      warnings.add(message, file: file)
    end

    # Prohibit directory traversal attack, e.g.
    # - '../../etc/passwd'
    # - 'config/../../../etc/passwd'
    def directory_traversal_attack?(path)
      abs_path = (current_dir / path).expand_path.to_s
      abs_current_dir_path = current_dir.expand_path.to_s
      !abs_path.start_with?(abs_current_dir_path)
    end

    def show_runtime_versions
      default_analyzer_version
    end

    def report_file
      @report_file ||= Tempfile.create(["#{analyzer_id}_report_", ".txt"]).path
    end

    def report_file_exist?
      File.file? report_file
    end

    def read_report_file(file_path = report_file)
      trace_writer.message "Reading output from #{file_path}..."
      File.read(file_path).tap do |output|
        if output.empty?
          trace_writer.message "No output"
        else
          trace_writer.message output
        end
      end
    end

    class InvalidXML < SystemError; end

    def read_xml(text)
      Nokogiri::XML(text) do |config|
        config.strict
      end
    rescue Nokogiri::XML::SyntaxError => exn
      message =
        if exn.cause.instance_of? RuntimeError
          exn.cause.message
        else
          exn.message
        end
      trace_writer.error message
      raise InvalidXML, message
    end

    def read_report_xml(file_path = report_file)
      output = read_report_file(file_path)
      read_xml(output)
    end

    def read_report_json(file_path = report_file)
      output = read_report_file(file_path)
      if output.empty? && block_given?
        yield
      else
        JSON.parse(output, symbolize_names: true)
      end
    end

    def comma_separated_list(value)
      values = Array(value).flat_map { |s| s.split(/\s*,\s*/) }
      values.empty? ? nil : values.join(",")
    end

    def extract_urls(text)
      return [] unless text

      @extract_urls_regexp ||= URI::DEFAULT_PARSER.make_regexp(["http", "https"])
      text.to_enum(:scan, @extract_urls_regexp).map do
        match = Regexp.last_match or raise
        uri = match[0] or raise
        uri.delete_suffix(",").delete_suffix(")")
      end.uniq
    end
  end
end
