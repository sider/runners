module Runners
  class Processor
    class CIConfigBroken < UserError; end

    attr_reader :guid, :workspace, :working_dir, :git_ssh_path, :trace_writer, :warnings, :config, :shell

    delegate :push_dir, :current_dir, :capture3, :capture3!, :capture3_trace, :capture3_with_retry!, to: :shell
    delegate :env_hash, :push_env_hash, to: :shell

    def self.register_config_schema(**args)
      Schema::Config.register(**args)
    end

    def initialize(guid:, workspace:, config:, git_ssh_path:, trace_writer:)
      @guid = guid
      @workspace = workspace
      @working_dir = workspace.working_dir
      @git_ssh_path = git_ssh_path
      @trace_writer = trace_writer
      @warnings = []
      @config = config

      if config.path_exist?
        trace_writer.ci_config(config.content, raw_content: config.raw_content!, file: config.path_name)
      end

      hash = {
        "RUBYOPT" => nil,
        "GIT_SSH" => git_ssh_path&.to_path,
      }
      @shell = Shell.new(current_dir: working_dir,
                         env_hash: hash,
                         trace_writer: trace_writer)
    end

    def relative_path(original, from: working_dir)
      path = Pathname(original)
      if path.relative?
        path = (current_dir / path).cleanpath
      end

      path.relative_path_from(from)
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

    def analyzer
      @analyzer ||= Analyzer.new(name: analyzer_name, version: analyzer_version)
    end

    def analyzer_bin
      analyzer_id
    end

    def analyzer_version
      @analyzer_version ||= extract_version! analyzer_bin
    end

    def extract_version!(command, version_option = "--version", pattern: /v?(\d+\.\d+(\.\d+)?)\b/)
      single_command, *extra_commands = Array(command)
      command_options = extra_commands + Array(version_option)
      outputs = capture3!(single_command, *command_options)
      outputs.each do |output|
        pattern.match(output) do |match|
          found = match[1]
          return found if found
        end
      end
      raise "Not found version from '#{single_command} #{command_options.join(' ')}'"
    end

    def config_linter
      config.linter(analyzer_id)
    end

    def check_root_dir_exist
      return if root_dir.directory?

      message = "`#{relative_path(root_dir)}` directory is not found! Please check `#{config_field_path("root_dir")}` in your `#{config.path_name}`"
      trace_writer.error message
      Results::Failure.new(guid: guid, message: message)
    end

    def push_root_dir(&block)
      push_dir(root_dir, &block)
    end

    def root_dir
      config_linter[:root_dir]&.yield_self { |root| working_dir / root } || working_dir
    end

    def ensure_files(*paths)
      trace_writer.message "Checking if required file exists: #{paths.join(', ')}"

      file = paths.find {|path| (working_dir + path).file? }
      if file
        trace_writer.message "Found #{file}"
        yield file
      else
        trace_writer.error "No file found..."
        Results::MissingFilesFailure.new(guid: guid, files: paths)
      end
    end

    # Returns e.g. "$.linter.rubocop.gems"
    def config_field_path(*fields)
      "$.linter.#{analyzer_id}.#{fields.join('.')}"
    end

    def delete_unchanged_files(changes, except: [], only: [])
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
          The #{analyzer_version} and older versions are deprecated. Sider will drop these versions #{deadline_str}.
          Please consider upgrading to #{minimum} or a newer version.
        MSG
      end
    end

    def add_warning_if_deprecated_options(keys)
      deprecated_keys = config_linter.slice(*keys).compact.keys
        .map { |k| "`#{config_field_path(k)}`" }

      unless deprecated_keys.empty?
        add_warning <<~MSG, file: config.path_name
          DEPRECATION WARNING!!!
          The #{deprecated_keys.join(", ")} option(s) in your `#{config.path_name}` are deprecated and will be removed in the near future.
          Please update to the new option(s) according to our documentation (see #{analyzer_doc} ).
        MSG
      end
    end

    def add_warning_for_deprecated_linter(alternative:, ref:, deadline: nil)
      deadline_str = deadline ? deadline.strftime("on %B %-d, %Y") : "in the near future"
      add_warning <<~MSG, file: config.path_name
        DEPRECATION WARNING!!!
        The support for #{analyzer_name} is deprecated. Sider will drop these versions #{deadline_str}.
        Please consider using an alternative tool #{alternative}. See #{ref}
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

    def read_output_file(file_path)
      file_path_s = file_path.to_s
      trace_writer.message "Reading output from #{file_path_s}..."
      File.read(file_path_s).tap do |output|
        if output.empty?
          trace_writer.message "No output"
        else
          trace_writer.message output, limit: 24_000 # Prevent timeout
        end
      end
    end

    class InvalidXML < SystemError; end

    def read_output_xml(file_path)
      output = read_output_file(file_path)
      REXML::Document.new(output).tap do |document|
        unless document.root
          message = "Output XML is invalid from #{file_path}"
          trace_writer.error message
          raise InvalidXML, message
        end
      end
    end

    def read_output_json(file_path)
      output = read_output_file(file_path)
      if output.empty? && block_given?
        yield
      else
        JSON.parse(output, symbolize_names: true)
      end
    end
  end
end
