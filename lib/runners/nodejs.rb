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

    # This is actually private. Do not use it out of this class.
    attr_accessor :nodejs_force_default_version

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
    def install_nodejs_deps(constraints:, dependencies: config_linter[:dependencies], install_option: config_linter[:npm_install])
      # @type var dependencies: Array[String | Hash[Symbol, String]]
      dependencies = Array(dependencies)

      if !dependencies.empty?
        if install_option
          trace_writer.message "`#{config_field_path(:npm_install)}` in your `#{config.path_name}` is ignored."
        end

        deps = dependencies.map { |dep| dep.is_a?(Hash) ? dep.values.join("@") : dep }
        npm_install(*deps)
      else
        flags = []
        case install_option
        when INSTALL_OPTION_NONE
          return # noop
        when INSTALL_OPTION_PRODUCTION
          flags << "--only=production"
        when INSTALL_OPTION_DEVELOPMENT
          add_warning <<~MSG, file: PACKAGE_JSON
            `#{INSTALL_OPTION_DEVELOPMENT}` of `#{config_field_path(:npm_install)}` is deprecated. It falls back to `#{INSTALL_OPTION_ALL}` instead.
          MSG
        end

        if package_json_path.exist?
          npm_install subcommand: (package_lock_json_path.exist? ? "ci" : "install"), flags: flags
        elsif install_option
          add_warning <<~MSG, file: PACKAGE_JSON
            Although `#{config_field_path(:npm_install)}` is enabled in your `#{config.path_name}`, `#{PACKAGE_JSON}` is missing in your repository.
          MSG
          return # noop
        else
          return # noop
        end
      end

      installed_deps = list_installed_npm_deps_with names: constraints.keys

      case
      when !all_npm_deps_satisfied_constraint?(installed_deps, constraints)
        self.nodejs_force_default_version = true
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
      !nodejs_force_default_version && nodejs_analyzer_locally_installed?
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
    def npm_install(*deps, subcommand: "install", flags: [])
      # NOTE: `--force` is to install *unmet* dependencies like npm 6 or Yarn.
      flags = %w[
        --force
        --ignore-scripts
        --no-audit
        --no-engine-strict
        --no-fund
        --no-progress
        --no-save
        --no-update-notifier
      ] + flags

      trace_writer.message "Installing npm dependencies..."

      begin
        ensure_same_yarn_lock do
          capture3_with_retry! "npm", subcommand, *flags, *deps
        end
      rescue Shell::ExecError
        message = <<~MSG.strip
          `npm #{subcommand}` failed. If you want to avoid this installation, try one of the following in your `#{config.path_name}`:

          - Set `#{INSTALL_OPTION_NONE}` to `#{config_field_path(:npm_install)}`
          - Set necessary packages to `#{config_field_path(:dependencies)}`

          See also <https://help.sider.review/getting-started/custom-configuration>
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

    def all_npm_deps_satisfied_constraint?(installed_deps, constraints)
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
