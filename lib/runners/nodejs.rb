module Runners
  module Nodejs
    class InvalidNodeVersion < SystemError; end
    class InvalidNpmVersion < SystemError; end
    class InvalidYarnVersion < SystemError; end

    class NpmInstallFailed < UserError; end
    class YarnInstallFailed < UserError; end

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

    # Return the actual file path of `yarn.lock`.
    def yarn_lock_path
      current_dir / "yarn.lock"
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
            The `npm_install` option is specified in your `#{config.path_name}`, but a `#{PACKAGE_JSON}` file is not found in the repository.
            In this case, any npm packages are not installed.
          MSG
        end

        return # not install
      end

      trace_writer.message "Installing npm packages..."

      install_option = INSTALL_OPTION_ALL if install_option.nil?

      if yarn_lock_path.exist?
        if package_lock_json_path.exist?
          file = yarn_lock_path.basename.to_path
          add_warning <<~MSG, file: file
            Two lock files `#{package_lock_json_path.basename}` and `#{file}` are found. Sider uses `#{file}` in this case, but please consider deleting either file for more accurate analysis.
          MSG
        end
        yarn_install(install_option)
      else
        npm_install(install_option)
      end

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
      run_yarn "-v"
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

    # @see https://docs.npmjs.com/cli/install
    # @see https://docs.npmjs.com/cli/ci
    def npm_install(option)
      cli_options = %w[
        --ignore-scripts
        --progress=false
        --engine-strict=false
      ]

      if package_lock_json_path.exist?
        subcommand = "ci"
      else
        subcommand = "install"
        cli_options << "--package-lock=false"
      end

      case option
      when INSTALL_OPTION_NONE
        return
      when INSTALL_OPTION_ALL
        # noop
      when INSTALL_OPTION_PRODUCTION
        cli_options << "--only=production"
      when INSTALL_OPTION_DEVELOPMENT
        cli_options << "--only=development"

        # NOTE: `npm ci --only=development` doesn't install anything. This seems to be a npm's bug.
        #
        # So this code fallback to `npm install` instead of `npm ci` to prevent analyses failing.
        if subcommand == "ci"
          subcommand = "install"
          cli_options << "--package-lock=false"
          add_warning <<~MSG, file: PACKAGE_JSON
            The `npm ci --only=development` command does not install anything, so `npm install --only=development` will be used instead.
            If you want to use `npm ci`, please change your install option from `#{INSTALL_OPTION_DEVELOPMENT}` to `#{INSTALL_OPTION_ALL}`.
            For details about the npm behavior, see https://npm.community/t/npm-ci-only-dev-does-not-install-anything/3068
          MSG
        end
      else
        raise "Unknown install option: #{option}"
      end

      begin
        capture3_with_retry! "npm", subcommand, *cli_options
      rescue Shell::ExecError
        message = <<~MSG.strip
          `npm #{subcommand}` failed. Please check the log for details.
          If you want to explicitly disable the installation, please set `npm_install: #{INSTALL_OPTION_NONE}` on your `#{config.path_name}`.
        MSG
        trace_writer.error message
        raise NpmInstallFailed, message
      end
    end

    def run_yarn(arg, *args)
      # NOTE: Avoid the effects of `.yarnrc` or `.yarnrc.yml`.
      #
      # @see https://classic.yarnpkg.com/en/docs/yarnrc/#toc-yarn-path
      # @see https://yarnpkg.com/configuration/yarnrc#yarnPath
      yarnrc_files = [".yarnrc", ".yarnrc.yml", ".yarnrc.yaml"].filter_map do |file|
        src = current_dir / file
        src if src.exist?
      end

      mktmpdir do |backup_dir|
        backup_files = yarnrc_files.map do |src|
          (backup_dir / src.basename).tap { |dst| src.rename(dst) }
        end

        begin
          capture3! "yarn", arg, *args
        ensure
          backup_files.each { |file| file.rename(current_dir / file.basename) }
        end
      end
    end

    # @see https://classic.yarnpkg.com/en/docs/cli/install
    def yarn_install(option)
      cli_options = %w[
        --ignore-engines
        --ignore-scripts
        --no-progress
        --non-interactive
        --frozen-lockfile
      ]

      case option
      when INSTALL_OPTION_NONE
        return
      when INSTALL_OPTION_ALL
        # noop
      when INSTALL_OPTION_PRODUCTION
        cli_options << "--production"
      when INSTALL_OPTION_DEVELOPMENT
        add_warning <<~MSG, file: "yarn.lock"
          Yarn does not have a same feature as `npm install --only=development`, so the option `#{INSTALL_OPTION_DEVELOPMENT}` will be ignored.
          See https://github.com/yarnpkg/yarn/issues/3254 for details.
        MSG
      else
        raise "Unknown install option: #{option}"
      end

      begin
        run_yarn "install", *cli_options
      rescue Shell::ExecError
        message = "`yarn install` failed. Please confirm `yarn.lock` is consistent with `#{PACKAGE_JSON}`."
        trace_writer.error message
        raise YarnInstallFailed, message
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
  end
end
