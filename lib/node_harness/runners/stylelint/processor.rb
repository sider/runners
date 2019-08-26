module NodeHarness
  module Runners
    module Stylelint
      class Processor < NodeHarness::Processor
        include NodeHarness::Nodejs

        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.npm.update_fields { |fields|
            fields.merge!({
                            config: string?,
                            syntax: string?,
                            'ignore-path': string?,
                            'ignore-disables': boolean?,
                            'report-needless-disables': boolean?,
                            quiet: boolean?,
                            glob: string?,
                            # NOTE: DO NOT ADD ANY OPTIONS to under `options` option.
                            options: optional(object(
                                                config: string?,
                                                'ignore-path': string?,
                                                syntax: string?,
                                                'ignore-disables': boolean?,
                                                'report-needless-disables': boolean?,
                                                quiet: boolean?,
                                                glob: string?
                                              ))
                          })
          }
        end

        DEFAULT_DEPS = DefaultDependencies.new(
          main: Dependency.new(name: "stylelint", version: "10.1.0"),
          extras: [
            Dependency.new(name: "stylelint-config-recommended", version: "2.2.0"),
          ],
        ).freeze

        CONSTRAINTS = {
          "stylelint" => Constraint.new(">= 8.3.0", "< 11.0.0"),
        }.freeze

        DEFAULT_TARGET_FILE_EXTENSIONS = ["css", "less", "sass", "scss", "sss"].freeze
        DEFAULT_GLOB = "**/*.{#{DEFAULT_TARGET_FILE_EXTENSIONS.join(',')}}".freeze

        def self.ci_config_section_name
          'stylelint'.freeze
        end

        def nodejs_analyzer_command
          "stylelint"
        end

        def setup
          prepare_ignore_file

          ensure_runner_config_schema(Schema.runner_config) do |config|
            begin
              install_nodejs_deps(DEFAULT_DEPS, constraints: CONSTRAINTS, install_option: config[:npm_install])
            rescue UserError => exn
              return NodeHarness::Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
            end

            # Must do after installation
            prepare_config_file(config)
            analyzer

            yield
          end
        end

        def analyzer
          @analyzer ||= NodeHarness::Analyzer.new(name: 'stylelint', version: nodejs_analyzer_version)
        end

        def analyze(changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            delete_unchanged_files(changes, only: DEFAULT_TARGET_FILE_EXTENSIONS.map { |ext| "*.#{ext}" })

            check_runner_config(config) do |glob, additional_options|
              run_analyzer(config, glob, additional_options)
            end
          end
        end

        private

        def check_runner_config(config)
          # Required Options which have default values.
          glob = glob(config)

          # Additional Options
          stylelintrc = stylelint_config(config)
          s = syntax(config)
          i = ignore_path(config)
          id = ignore_disables(config)
          rd = report_needless_disables(config)
          q = quiet(config)

          additional_options = [stylelintrc, s, i, id, rd, q].flatten.compact
          yield glob, additional_options
        end

        def glob(config)
          config[:glob] || config.dig(:options, :glob) || DEFAULT_GLOB
        end

        def stylelint_config(config)
          stylelintrc = config[:config] || config.dig(:options, :config)
          "--config=#{stylelintrc}" if stylelintrc
        end

        def syntax(config)
          syntax = config[:syntax] || config.dig(:options, :syntax)
          "--syntax=#{syntax}" if syntax
        end

        def ignore_path(config)
          # FIXME: This `@type` comment is unneeded ideally.
          # @type var config: any
          ignore_path = config[:'ignore-path'] || config.dig(:options, :'ignore-path')
          "--ignore-path=#{ignore_path}" if ignore_path
        end

        def ignore_disables(config)
          # FIXME: This `@type` comment is unneeded ideally.
          # @type var config: any
          ignore_disables = config[:'ignore-disables'] || config.dig(:options, :'ignore-disables')
          "--ignore-disables" if ignore_disables
        end

        def report_needless_disables(config)
          # FIXME: This `@type` comment is unneeded ideally.
          # @type var config: any
          rd = config[:'report-needless-disables'] || config.dig(:options, :'report-needless-disables')
          "--report-needless-disables" if rd
        end

        def quiet(config)
          quiet = config[:quiet] || config.dig(:options, :quiet)
          "--quiet" if quiet
        end

        def parse_result(stdout)
          JSON.parse(stdout).flat_map do |file|
            check_warning(file['deprecations'])
            fname = file['source']
            file['warnings'].map do |warn|
              loc = NodeHarness::Location.new(
                start_line: warn['line'] || 1, # NOTE: There is a rare case that stylelint doesn't output the `line`.
                start_column: nil,
                end_line: nil,
                end_column: nil
              )
              NodeHarness::Issues::Text.new(
                path: relative_path(fname),
                location: loc,
                id: warn['rule'],
                message: warn['text'],
                links: []
              )
            end
          end
        end

        def prepare_config_file(config)
          return if config_file_path(config)

          src = (Pathname(Dir.home) / 'sider_recommended_config.yaml').realpath
          dst = current_dir.join('.stylelintrc.yaml')
          FileUtils.cp(src, dst)
        end

        def prepare_ignore_file
          ignore_file_path = current_dir.join('.stylelintignore')
          return if ignore_file_path.file?
          src = (Pathname(Dir.home) / 'sider_recommended_stylelintignore').realpath
          FileUtils.cp(src, ignore_file_path)
        end

        # returns available config file path. If the file doesn't exist, it returns nil.
        def config_file_path(config)
          config_path = config[:config] || config.dig(:options, :config)
          if config_path
            current_dir / config_path
          elsif package_json_path.exist? && package_json.key?(:stylelint)
            package_json_path
          else
            # @see https://github.com/stylelint/stylelint/blob/master/docs/user-guide/configuration.md
            candidates = %w[
              .stylelintrc
              .stylelintrc.js
              .stylelintrc.json
              .stylelintrc.yaml
              .stylelintrc.yml
              stylelint.config.js
            ]
            candidates.map { |filename| current_dir / filename }.find(&:exist?)
          end
        end

        def config_file_path!(config)
          config_file_path(config) or raise "Not found config file: #{config.inspect}"
        end

        def warning_set
          @warning_set ||= Set.new
        end

        # Save warnings written by stylelint.
        # stylelint writes "deprecations" flags in each file, so we cannot conduct naive implementations.
        # Without this method, if we write a warning when the "deprecations" appear,
        # the same number of duplicated warnings as files will appear.
        # We use `Set` to avoid it.
        #
        # @see https://github.com/stylelint/stylelint/blob/0fb8b6d561ca59830cb6d66addf588cfe6169ff1/lib/createStylelintResult.js#L6-L18
        def check_warning(deprecations)
          deprecations.each do |dep|
            warning_set << "#{dep['text']} #{dep['reference']}"
          end
        end

        def run_analyzer(config, glob, additional_options)
          default_options = ['--formatter=json', '--no-color']
          # stylelint v10.0.0 throws an error if glob matches no files.
          # @see https://github.com/stylelint/stylelint/releases/tag/10.0.0
          # This behavior is inconvenient when deleting unchanged files
          #
          # ---
          #
          # The `--allow-empty-input` option breaks with v10.0.0. Fixed with v10.0.1.
          # @see https://github.com/stylelint/stylelint/releases/tag/10.0.1
          # @see https://github.com/stylelint/stylelint/pull/4029
          if Gem::Version.new(nodejs_analyzer_version) >= Gem::Version.new("10.0.1")
            default_options << '--allow-empty-input'
          end

          stdout, stderr, status = capture3(
            nodejs_analyzer_bin,
            *default_options,
            *additional_options,
            glob
          )

          # https://github.com/stylelint/stylelint/blob/master/docs/user-guide/cli.md#exit-codes
          # 0 => No Issues
          # 2 => Issues exist
          # Others => Something wrong, target files don't exist, ...
          unless [0, 2].include?(status.exitstatus)
            return NodeHarness::Results::Failure.new(guid: guid, message: [stdout, stderr].join("\n"), analyzer: analyzer!)
          end

          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            parse_result(stdout).each { |v| result.add_issue(v) }

            conf_path = relative_path(config_file_path!(config)).to_s
            warning_set.sort.each do |warning|
              add_warning(warning, file: conf_path)
            end
          end
        end
      end
    end
  end
end
