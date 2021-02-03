module Runners
  class Processor
    extend Forwardable
    include Tmpdir

    class CIConfigBroken < UserError; end

    def self.register_config_schema(name:, schema:)
      Schema::Config.register(name: name, schema: schema)
    end

    # TODO: Keep the following schemas for the backward compatibility.
    RemovedGoToolSchema = _ = StrongJSON.new do
      # @type self: RemovedGoToolSchemaClass
      let :config, any?
    end
    register_config_schema(name: :golint, schema: RemovedGoToolSchema.config)
    register_config_schema(name: :go_vet, schema: RemovedGoToolSchema.config)
    register_config_schema(name: :gometalinter, schema: RemovedGoToolSchema.config)

    attr_reader :guid, :working_dir, :config, :shell, :trace_writer, :warnings

    def_delegators :@shell,
      :chdir, :current_dir,
      :capture3, :capture3!, :capture3_trace, :capture3_with_retry!,
      :env_hash, :push_env_hash

    def initialize(guid:, working_dir:, config:, shell:, trace_writer:)
      @guid = guid
      @working_dir = working_dir
      @config = config
      @shell = shell
      @trace_writer = trace_writer
      @warnings = []

      if config.path_exist?
        trace_writer.ci_config(config.content, raw_content: config.raw_content!, file: config.path_name)
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

    # NOTE: This method should be defined dynamically.
    # def analyzer_id; end

    def analyzer_name
      analyzers.name(analyzer_id)
    end

    def analyzer_doc
      analyzers.doc(analyzer_id)
    end

    def analyzer_github
      analyzers.github(analyzer_id)
    end

    def analyzer
      @analyzer ||= Analyzer.new(name: analyzer_name, version: analyzer_version)
    end

    def analyzer_bin
      analyzer_id
    end

    def analyzer_version
      @analyzer_version ||= extract_version! analyzer_bin
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
      # TODO: Ignored Steep error
      outputs = capture3!(_ = cmd, *(_ = cmd_opts))
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
        Please create the file according to the following documents:
        - #{analyzer_github}
        - #{analyzer_doc}
      MSG

      Results::Success.new(guid: guid, analyzer: analyzer)
    end

    # Returns e.g. "linter.rubocop.gems"
    def config_field_path(*fields)
      "linter.#{analyzer_id}.#{fields.join('.')}"
    end

    def delete_unchanged_files(changes, except: [], only: [])
      return if changes.unchanged_paths.empty?

      trace_writer.message "Deleting unchanged files from working copy..." do
        files = changes.delete_unchanged(dir: working_dir, except: except, only: only)
        trace_writer.message files.join("\n")
      end
    end

    def add_warning(message, file: nil)
      message = message.strip
      trace_writer.warning(message, file: file)
      @warnings << {message: message, file: file}
    end

    def add_warning_if_deprecated_version(minimum:, file: nil, deadline: nil)
      unless Gem::Version.create(minimum) <= Gem::Version.create(analyzer_version)
        deadline_str = deadline ? deadline.strftime('on %B %-d, %Y') : 'in the near future'
        add_warning <<~MSG, file: file
          DEPRECATION WARNING!!!
          The `#{analyzer_version}` and older versions are deprecated, and these versions will be dropped #{deadline_str}.
          Please consider upgrading to `#{minimum}` or a newer version.
        MSG
      end
    end

    def add_warning_if_deprecated_options
      name = :options
      return unless config_linter[name]

      file = config.path_name
      add_warning <<~MSG, file: file
        DEPRECATION WARNING!!!
        The `#{config_field_path(name)}` option is deprecated. Fix your `#{file}` as follows:
        See #{analyzer_doc} for details.

        ```diff
         linter:
           #{analyzer_id}:
        -    options:
        -      foo: "bar"
        +    foo: "bar"
        ```
      MSG
    end

    def add_warning_for_deprecated_option(name, to:)
      return unless config_linter[name]

      file = config.path_name
      add_warning <<~MSG, file: file
        DEPRECATION WARNING!!!
        The `#{config_field_path(name)}` option is deprecated. Use the `#{config_field_path(to)}` option instead in your `#{file}`.
        See #{analyzer_doc} for details.
      MSG
    end

    def add_warning_for_deprecated_linter(alternative:, ref:, deadline: nil)
      deadline_str = deadline ? deadline.strftime("on %B %-d, %Y") : "in the near future"
      add_warning <<~MSG, file: config.path_name
        DEPRECATION WARNING!!!
        The support for #{analyzer_name} is deprecated and will be removed #{deadline_str}.
        Please migrate to #{alternative} as an alternative. See #{ref}
      MSG
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
      # noop by default
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
      root = REXML::Document.new(text).root
      if root
        root
      else
        message = "Invalid XML: #{text.inspect}"
        trace_writer.error message
        raise InvalidXML, message
      end
    rescue REXML::ParseException => exn
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
      # TODO: Ignored Steep error
      values = Array(value).flat_map { |s| (_ = s).split(/\s*,\s*/) }
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
