module Runners
  module Ruby
    class InstallGemsFailure < UserError; end

    def install_gems(default_specs, constraints:, optionals: [], &block)
      original_default_specs = default_specs.dup
      user_specs = GemInstaller::Spec.from_gems(config_linter[:gems] || [])

      LockfileLoader.new(root_dir: root_dir, shell: shell).ensure_lockfile do |lockfile|
        default_specs = default_specs(default_specs, constraints, lockfile)
        optionals = optional_specs(optionals, lockfile)
        user_specs = user_specs(user_specs, lockfile)
      end
      use_local = (user_specs + optionals).empty? && original_default_specs == default_specs
      specs = GemInstaller::Spec.merge(default_specs, user_specs.size > 0 ? user_specs : optionals)

      mktmpdir do |path|
        installer = GemInstaller.new(shell: shell,
                                     home: path,
                                     config_path_name: config.path_name,
                                     specs: specs,
                                     trace_writer: trace_writer,
                                     constraints: constraints,
                                     use_local: use_local)
        installer.install!(&block)
      end
    end

    private def default_specs(specs, constraints, lockfile)
      specs.map do |spec|
        if lockfile.spec_exists?(spec)
          if lockfile.satisfied_by?(spec, constraints)
            spec.override_by_lockfile(lockfile)
          else
            locked_version = lockfile.locked_version!(spec)
            add_warning <<~MESSAGE
              `#{spec.name} #{spec.version.first}` is installed instead of `#{locked_version}` in your `Gemfile.lock`.
              Because `#{locked_version}` does not satisfy our constraints `#{constraints.fetch(spec.name)}`.

              If you want to use a different version of `#{spec.name}`, please do either:
              - Update your `Gemfile.lock` to satisfy the constraint
              - Set the `#{config_field_path(:gems)}` option in your `#{config.path_name}`
            MESSAGE
            spec
          end
        else
          spec
        end
      end
    end

    private def optional_specs(specs, lockfile)
      specs.select { |spec| lockfile.spec_exists?(spec) }
           .map { |spec| spec.override_by_lockfile(lockfile) }
    end

    private def user_specs(specs, lockfile)
      specs.map do |spec|
        if spec.version.empty?
          spec.override_by_lockfile(lockfile)
        else
          spec
        end
      end
    end

    def show_runtime_versions
      capture3! "ruby", "-v"
      capture3! "gem", "-v"
      capture3! "bundle", "-v"
    end

    def ruby_analyzer_command(*args)
      Command.new("bundle", ["exec", analyzer_bin, *args])
    end

    def analyzer_version
      @analyzer_version ||= extract_version! ruby_analyzer_command.to_a
    end

    def default_gem_specs(*gem_names)
      # @see https://guides.rubygems.org/command-reference/#gem-list
      stdout, = capture3! "gem", "list", "--quiet", "--exact", *gem_names

      gem_names.map do |name|
        # NOTE: A format example: `rubocop (0.75.1, 0.75.0)`
        version = /#{Regexp.escape(name)} \((.+)\)/.match(stdout)&.captures&.first
        if version
          GemInstaller::Spec.new(name: name, version: version.split(/,\s*/))
        else
          raise "Not found installed gem #{name.inspect}"
        end
      end
    end

    def gem_info(gem_name)
      @gem_info ||= {}
      info = @gem_info[gem_name]
      unless info
        info, _ = capture3! "gem", "info", "--both", "--exact", "--quiet", gem_name
        @gem_info[gem_name] = info
      end
      info
    end
  end
end
