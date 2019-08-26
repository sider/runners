module NodeHarness
  class Processor
    # @dynamic guid, working_dir, git_ssh_path, trace_writer, warnings, ci_config, ci_config_for_collect
    attr_reader :guid
    attr_reader :working_dir
    attr_reader :git_ssh_path
    attr_reader :trace_writer
    attr_reader :warnings
    attr_reader :ci_config
    attr_reader :ci_config_for_collect
    attr_reader :shell

    def initialize(guid:, working_dir:, git_ssh_path:, trace_writer:)
      @guid = guid
      @working_dir = working_dir
      @git_ssh_path = git_ssh_path
      @trace_writer = trace_writer
      @warnings = []
      @ci_config =
        if ci_config_path.file?
          begin
            YAML.load_file(ci_config_path.to_s, fallback: {}).tap do |conf|
              trace_writer.ci_config(conf)
            end
          rescue Psych::SyntaxError => exn
            trace_writer.error("Parse error occurred: #{exn}")
            raise
          end
        end
      # Runner maybe break `@ci_config`.
      # So we should deep copy it to avoid collecting incorrect config file.
      @ci_config_for_collect = Marshal.load(Marshal.dump(@ci_config))

      hash = {
        "RUBYOPT" => nil,
        "GIT_SSH" => git_ssh_path,
      }
      @shell = Shell.new(current_dir: working_dir,
                         env_hash: hash,
                         trace_writer: trace_writer)
    end

    def relative_path(path_string, from: working_dir)
      path = Pathname(path_string)
      if path.relative?
        path = (current_dir + path).cleanpath
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

    def with_analyzer(analyzer)
      old_analyzer = @analyzer
      @analyzer = analyzer
      yield
    ensure
      @analyzer = old_analyzer
    end

    def analyzer
      @analyzer
    end

    def analyzer!
      analyzer or raise "No analyzer set"
    end

    def analyzer_version
      raise NotImplementedError
    end

    def self.ci_config_section_name
      self.name
    end

    def ci_config_path
      new_config_path = working_dir + "sider.yml"
      if new_config_path.file?
        new_config_path
      else
        working_dir + "sideci.yml"
      end
    end

    def ci_config_path_name
      if ci_config_path.file?
        File.basename(ci_config_path)
      else
        "sider.yml"
      end
    end

    def ci_section(default = {})
      section = ci_config&.dig("linter", self.class.ci_config_section_name)
      default.deep_merge(Hash(section))
    end

    def push_root_dir(&block)
      root_dir = ci_section["root_dir"]
      if root_dir
        push_dir(working_dir + root_dir, &block)
      else
        yield
      end
    end

    def root_dir
      root_dir = ci_section["root_dir"]
      if root_dir
        working_dir + root_dir
      else
        working_dir
      end
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

    # @param schema [StrongJSON]
    def ensure_runner_config_schema(schema)
      config =
        begin
          schema.coerce(ci_section.deep_symbolize_keys)
        rescue StrongJSON::Type::UnexpectedAttributeError => error
          message = "Invalid configuration in #{ci_config_path_name}: unknown attribute at config: #{build_field_reference_from_path(error.path)}"
          trace_writer.error message
          return NodeHarness::Results::Failure.new(
            guid: guid,
            message: message,
            analyzer: nil
          )
        rescue StrongJSON::Type::TypeError => error
          message = "Invalid configuration in #{ci_config_path_name}: unexpected value at config: #{build_field_reference_from_path(error.path)}"
          trace_writer.error message
          return NodeHarness::Results::Failure.new(
            guid: guid,
            message: message,
            analyzer: nil
          )
        end
      yield config
    end

    # @param path [StrongJSON::Type::ErrorPath]
    # @return String "$.linter.rubocop.gems"
    def build_field_reference_from_path(path)
      path.to_s.sub('$', "$.linter.#{self.class.ci_config_section_name}")
    end

    def push_dir(path, &block)
      shell.push_dir(path, &block)
    end

    def current_dir
      shell.current_dir
    end

    def capture3(command, *args)
      shell.capture3(command, *args)
    end

    def capture3!(command, *args)
      shell.capture3!(command, *args)
    end

    def capture3_trace(command, *args)
      shell.capture3_trace(command, *args)
    end

    def capture3_with_retry!(command, *args, tries: 3)
      shell.capture3_with_retry!(command, *args, tries: tries)
    end

    def delete_unchanged_files(changes, except: [], only: [])
      trace_writer.message "Deleting unchanged files from working copy..." do
        changes.delete_unchanged(dir: working_dir, except: except, only: only) do |path|
          trace_writer.message "Deleted #{path}"
        end
      end
    end

    def env_hash
      shell.env_hash
    end

    def push_env_hash(env, &block)
      shell.push_env_hash(env, &block)
    end

    def add_warning(message, file: nil)
      trace_writer.warning(message, file: file)
      @warnings << {message: message, file: file}
    end

    # Prohibit directory traversal attack, e.g.
    # - '../../etc/passwd'
    # - 'config/../../../etc/passwd'
    def directory_traversal_attack?(path)
      abs_path = (current_dir / path).expand_path.to_s
      abs_current_dir_path = current_dir.expand_path.to_s
      !abs_path.start_with?(abs_current_dir_path)
    end
  end
end
