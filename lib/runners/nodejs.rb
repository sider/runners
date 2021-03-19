module Runners
  module Nodejs
    class InvalidNodeVersion < SystemError; end
    class InvalidNpmVersion < SystemError; end

    class NpmInstallFailed < UserError; end

    INSTALL_OPTION_NONE = false
    INSTALL_OPTION_ALL = true
    INSTALL_OPTION_PRODUCTION = "production".freeze
    INSTALL_OPTION_DEVELOPMENT = "development".freeze

    PACKAGE_JSON = "package.json".freeze

    # Return the locally installed analyzer command.
    def nodejs_analyzer_local_command
      File.join("node_modules", ".bin", analyzer_bin)
    end

    # Return the analyzer command which will actually be ran.
    def nodejs_analyzer_bin
      nodejs_use_local_version? ? nodejs_analyzer_local_command : analyzer_bin
    end

    def analyzer_version
      @analyzer_version ||= nodejs_use_local_version? ? nodejs_analyzer_local_version : nodejs_analyzer_global_version
    end

    # Return the actual file path of `package.json`.
    def package_json_path
      current_dir / PACKAGE_JSON
    end

    # Return the `Hash` content of `package.json`.
    def package_json
      @package_json ||= JSON.parse(package_json_path.read(encoding: Encoding::UTF_8), symbolize_names: true)
    end

    # Return the actual file path of `package-lock.json`.
    def package_lock_json_path
      current_dir / "package-lock.json"
    end

    def node_modules_path
      current_dir / "node_modules"
    end

    # Install Node.js dependencies by using given parameters.
    def install_nodejs_deps(constraints:, install_option: config_linter[:npm_install])
      return if install_option == INSTALL_OPTION_NONE

      unless package_json_path.exist?
        if install_option
          add_warning <<~MSG, file: PACKAGE_JSON
            The `npm_install` option is specified in your `#{config.path_name}`, but a `#{PACKAGE_JSON}` file is not found in your repository.
            In this case, any npm packages are not installed.
          MSG
        end

        return # not install
      end

      trace_writer.message "Installing npm packages..."

      cli_flags = []
      case install_option
      when INSTALL_OPTION_PRODUCTION
        cli_flags << "--only=production"
      when INSTALL_OPTION_DEVELOPMENT
        add_warning <<~MSG, file: PACKAGE_JSON
          `npm_install: #{INSTALL_OPTION_DEVELOPMENT}` has been deprecated and falls back to `npm_install: #{INSTALL_OPTION_ALL}`.
        MSG
      end
      npm_install subcommand: (package_lock_json_path.exist? ? "ci" : "install"), flags: cli_flags

      installed_deps = list_installed_npm_deps_with(names: constraints.keys)

      case
      when !all_npm_deps_statisfied_constraint?(installed_deps, constraints)
        @nodejs_force_default_version = true
        trace_writer.message "All constraints are not satisfied. The default version `#{analyzer_version}` will be used instead."
      when nodejs_analyzer_locally_installed?
        trace_writer.message "`#{nodejs_analyzer_local_command}` was successfully installed with the version `#{analyzer_version}`."
      else
        trace_writer.message "`#{nodejs_analyzer_local_command}` was not installed. The default version `#{analyzer_version}` will be used instead."
      end
    end

    def show_runtime_versions
      capture3! "node", "-v"
      capture3! "npm", "-v"
    end

    private

    def nodejs_use_local_version?
      !@nodejs_force_default_version && nodejs_analyzer_locally_installed?
    end

    def nodejs_analyzer_locally_installed?
      (current_dir / nodejs_analyzer_local_command).exist?
    end

    def nodejs_analyzer_global_version
      @nodejs_analyzer_global_version ||= extract_version!(analyzer_bin)
    end

    def nodejs_analyzer_local_version
      @nodejs_analyzer_local_version ||= extract_version!(nodejs_analyzer_local_command)
    end

    # @see https://docs.npmjs.com/cli/v7/commands/npm-install
    # @see https://docs.npmjs.com/cli/v7/commands/npm-ci
    def npm_install(subcommand: "install", flags: [])
      flags = %w[
        --ignore-scripts
        --no-engine-strict
        --no-progress
        --no-save
      ] + flags

      begin
        ensure_same_yarn_lock do
          capture3_with_retry! "npm", subcommand, *flags
        end
      rescue Shell::ExecError
        message = <<~MSG.strip
          `npm #{subcommand}` failed. Please check the log for details.
          If you want to explicitly disable the installation, please set `npm_install: #{INSTALL_OPTION_NONE}` in your `#{config.path_name}`.
        MSG
        trace_writer.error message
        raise NpmInstallFailed, message
      end
    end

    def list_installed_npm_deps_with(names:)
      return {} unless node_modules_path.exist?

      names.each_with_object({}) do |name, result|
        pkg = node_modules_path / name / PACKAGE_JSON
        next unless pkg.exist?

        installed = JSON.parse(pkg.read(encoding: Encoding::UTF_8), symbolize_names: true)

        unless name == installed.fetch(:name)
          raise "Name mismatch: #{name.inspect} != #{installed.fetch(:name).inspect}"
        end

        version = installed.fetch(:version)
        result[name] = { name: name, version: version }
      end
    end

    def all_npm_deps_statisfied_constraint?(installed_deps, constraints)
      all_satisfied = true

      constraints.each do |name, constraint|
        installed = installed_deps[name]

        if installed
          version = installed.fetch(:version)
          unless constraint.satisfied_by? Gem::Version.new(version)
            add_warning <<~MSG, file: PACKAGE_JSON
              Installed `#{name}@#{version}` does not satisfy our constraint `#{npm_constraint_format(constraint)}`. Please update it as possible.
            MSG
            all_satisfied = false
          end
        else
          trace_writer.message "`#{name}` is required but not installed (not in your `#{PACKAGE_JSON}`)."
          all_satisfied = false
        end
      end

      all_satisfied
    end

    def npm_constraint_format(constraint)
      # @see https://docs.npmjs.com/cli/v7/configuring-npm/package-json#dependencies
      constraint.to_s.delete(" ").sub(",", " ")
    end

    # HACK: This code prevents `yarn.lock` from being overwritten via `npm install` unexpectedly.
    #       This behavior seems a bug of npm but I'm not sure and cannot find related issues...
    def ensure_same_yarn_lock
      yarn_lock = current_dir / "yarn.lock"
      return yield unless yarn_lock.exist?

      backup_content = yarn_lock.read
      begin
        yield
      ensure
        yarn_lock.write backup_content
      end
    end
  end
end
