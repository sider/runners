module Runners
  class Processor
    class CIConfigBroken < UserError; end

    attr_reader :guid, :workspace, :working_dir, :git_ssh_path, :trace_writer, :warnings, :ci_config, :ci_config_for_collect, :shell

    delegate :push_dir, :current_dir, :capture3, :capture3!, :capture3_trace, :capture3_with_retry!, to: :shell
    delegate :env_hash, :push_env_hash, to: :shell

    def initialize(guid:, workspace:, git_ssh_path:, trace_writer:)
      @guid = guid
      @workspace = workspace
      @working_dir = workspace.working_dir
      @git_ssh_path = git_ssh_path
      @trace_writer = trace_writer
      @warnings = []
      @ci_config =
        if ci_config_path.file?
          begin
            YAML.load_file(ci_config_path.to_s, fallback: {}).tap do |conf|
              trace_writer.ci_config(conf, file: ci_config_path.basename.to_s)
            end
          rescue Psych::SyntaxError => exn
            message = "Your `#{relative_path(ci_config_path.to_s)}` file may be broken (line #{exn.line}, column #{exn.column})."
            trace_writer.error message
            raise CIConfigBroken.new(message)
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

    def analyzer_name
      raise NotImplementedError, "No implementation: #{self.class}#{__method__}"
    end

    def analyzer
      @analyzer ||= Analyzer.new(name: analyzer_name, version: analyzer_version)
    end

    def analyzer_bin
      self.class.ci_config_section_name
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

    def ci_section_root_dir
      ci_section["root_dir"]
    end

    def check_root_dir_exist
      root_dir = ci_section_root_dir
      if root_dir
        return if (working_dir / root_dir).directory?

        message = "`#{root_dir}` directory is not found!" \
          " Please check `linter.#{self.class.ci_config_section_name}.root_dir` in your `#{ci_config_path_name}`"
        trace_writer.error message
        Results::Failure.new(guid: guid, message: message)
      end
    end

    def push_root_dir(&block)
      root_dir = ci_section_root_dir
      if root_dir
        push_dir(working_dir + root_dir, &block)
      else
        yield
      end
    end

    def root_dir
      root_dir = ci_section_root_dir
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
          message = "Invalid configuration in `#{ci_config_path_name}`: unknown attribute at config: `#{build_field_reference_from_path(error.path)}`"
          trace_writer.error message
          return Results::Failure.new(
            guid: guid,
            message: message,
            analyzer: nil
          )
        rescue StrongJSON::Type::TypeError => error
          message = "Invalid configuration in `#{ci_config_path_name}`: unexpected value at config: `#{build_field_reference_from_path(error.path)}`"
          trace_writer.error message
          return Results::Failure.new(
            guid: guid,
            message: message,
            analyzer: nil
          )
        end
      yield config
    end

    # Returns e.g. "$.linter.rubocop.gems"
    def build_field_reference_from_path(path)
      path.to_s.sub('$', "$.linter.#{self.class.ci_config_section_name}")
    end

    def delete_unchanged_files(changes, except: [], only: [])
      trace_writer.message "Deleting unchanged files from working copy..." do
        files = changes.delete_unchanged(dir: working_dir, except: except, only: only)
        trace_writer.message files.join("\n")
      end
    end

    def add_warning(message, file: nil)
      trace_writer.warning(message, file: file)
      @warnings << {message: message, file: file}
    end

    def add_warning_if_deprecated_version(minimum:, file: nil, deadline: nil)
      unless Gem::Version.create(minimum) <= Gem::Version.create(analyzer_version)
        deadline_str = deadline ? deadline.strftime('on %B %-d, %Y') : 'in the near future'
        add_warning <<~MSG.strip, file: file
          DEPRECATION WARNING!!!
          The #{analyzer_version} and older versions are deprecated. Sider will drop these versions #{deadline_str}.
          Please consider upgrading to #{minimum} or a newer version.
        MSG
      end
    end

    def add_warning_if_deprecated_options(keys, doc:)
      deprecated_keys = ci_section.symbolize_keys.slice(*keys).keys
        .map { |k| "`" + build_field_reference_from_path("$.#{k}") + "`" }

      unless deprecated_keys.empty?
        add_warning <<~MSG.strip, file: ci_config_path_name
          DEPRECATION WARNING!!!
          The #{deprecated_keys.join(", ")} option(s) in your `#{ci_config_path_name}` are deprecated and will be removed in the near future.
          Please update to the new option(s) according to our documentation (see #{doc} ).
        MSG
      end
    end

    def add_warning_for_deprecated_linter(alternative:, deadline: nil)
      deadline_str = deadline ? deadline.strftime("on %B %-d, %Y") : "in the near future"
      add_warning <<~MSG.strip, file: ci_config_path_name
        DEPRECATION WARNING!!!
        The support for #{analyzer_name} is deprecated. Sider will drop these versions #{deadline_str}.
        Please consider using an alternative tool #{alternative}.
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
  end
end
