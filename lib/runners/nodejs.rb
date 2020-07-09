module Runners
  module Nodejs
    class InvalidNodeVersion < SystemError; end
    class InvalidNpmVersion < SystemError; end
    class InvalidYarnVersion < SystemError; end

    class ConstraintsNotSatisfied < UserError; end
    class NpmInstallFailed < UserError; end
    class YarnInstallFailed < UserError; end

    INSTALL_OPTION_NONE = false
    INSTALL_OPTION_ALL = true
    INSTALL_OPTION_PRODUCTION = "production"
    INSTALL_OPTION_DEVELOPMENT = "development"

    # Return the locally installed analyzer command.
    def nodejs_analyzer_local_command
      "node_modules/.bin/#{analyzer_bin}"
    end

    # Return the analyzer command which will actually be ran.
    def nodejs_analyzer_bin
      nodejs_analyzer_locally_installed? ? nodejs_analyzer_local_command : analyzer_bin
    end

    def analyzer_version
      @analyzer_version ||= nodejs_analyzer_locally_installed? ? nodejs_analyzer_local_version : nodejs_analyzer_global_version
    end

    # Return the actual file path of `package.json`.
    def package_json_path
      current_dir / "package.json"
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

    # Install Node.js dependencies by using given parameters.
    def install_nodejs_deps(constraints:, install_option:)
      return if install_option == INSTALL_OPTION_NONE

      unless package_json_path.exist?
        if install_option
          file = package_json_path.basename.to_path
          add_warning <<~MSG, file: file
            The `npm_install` option is specified in your `#{config.path_name}`, but a `#{file}` file is not found in the repository.
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

      check_installed_nodejs_deps(constraints)

      if nodejs_analyzer_locally_installed?
        trace_writer.message <<~MSG
          `#{nodejs_analyzer_local_command}` was successfully installed with the version #{analyzer_version}.
        MSG
      else
        trace_writer.message <<~MSG
          `#{nodejs_analyzer_local_command}` was not installed. The default version #{analyzer_version} will be used instead.
        MSG
      end
    end

    def show_runtime_versions
      capture3! "node", "-v"
      capture3! "npm", "-v"
      capture3! "yarn", "-v"
    end

    private

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
          add_warning <<~MSG, file: "package.json"
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

    # @see https://yarnpkg.com/en/docs/cli/install
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
        capture3_with_retry! "yarn", "install", *cli_options
      rescue Shell::ExecError
        message = "`yarn install` failed. Please confirm `yarn.lock` is consistent with `package.json`."
        trace_writer.error message
        raise YarnInstallFailed, message
      end
    end

    def list_installed_nodejs_deps(only: [], chdir: nil)
      opts = { trace_stdout: false, chdir: chdir&.to_s }.compact

      # NOTE: `npm ls` fails when any peer dependencies are missing.
      #        Also, this scans `node_modules/` without `package-lock.json`.
      #        Also, the command output can be too long.
      stdout, _, _ = capture3 "npm", "ls", *only, "--depth=0", "--json", "--package-lock=false", **opts

      parsed = JSON.parse(stdout).dig("dependencies") or return {}

      parsed.each_with_object({}) do |(name, obj), deps|
        deps[name] = obj["version"] || ""
      end
    end

    def check_installed_nodejs_deps(constraints)
      installed_deps = list_installed_nodejs_deps

      return if installed_deps.empty?

      all_constraints_satisfied = true

      constraints.each do |name, constraint|
        unless installed_deps.key? name
          # NOTE: No required dependencies. Instead, use the default version.
          break
        end

        version = installed_deps.fetch(name)
        if version.empty?
          add_warning "The required dependency `#{name}` may not be installed and be a missing peer dependency.", file: "package.json"
          next
        end

        installed_dependency = Dependency.new(name: name, version: version)
        unless constraint.satisfied_by? installed_dependency
          trace_writer.error "The installed dependency `#{installed_dependency}` does not satisfy our constraint `#{constraint}`."
          all_constraints_satisfied = false
          next
        end
      end

      unless all_constraints_satisfied
        constraints_text = constraints.map { |name, constraint| "`#{name}@#{constraint}`" }.join(", ")
        message = <<~MSG.strip
          Your #{analyzer_name} dependencies do not satisfy our constraints #{constraints_text}. Please update them.
        MSG
        trace_writer.error message
        raise ConstraintsNotSatisfied, message
      end
    end
  end
end
