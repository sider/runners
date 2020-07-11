module Runners
  class Processor::Stylelint < Processor
    include Nodejs

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.npm.update_fields { |fields|
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

      let :issue, object(
        severity: string?,
      )
    end

    register_config_schema(name: :stylelint, schema: Schema.runner_config)

    CONSTRAINTS = {
      "stylelint" => Constraint.new(">= 8.3.0", "< 14.0.0"),
    }.freeze

    DEFAULT_TARGET_FILES = "*.{css,less,sass,scss,sss}".freeze
    DEFAULT_GLOB = "**/#{DEFAULT_TARGET_FILES}".freeze

    def setup
      add_warning_if_deprecated_options([:options])

      prepare_ignore_file

      begin
        install_nodejs_deps(constraints: CONSTRAINTS, install_option: config_linter[:npm_install])
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
      end

      # Must do after installation
      prepare_config_file

      yield
    end

    def analyze(changes)
      delete_unchanged_files(changes, only: [DEFAULT_TARGET_FILES])

      additional_options = [stylelint_config, syntax, ignore_path, ignore_disables,
                            report_needless_disables, quiet].flatten.compact
      run_analyzer(glob, additional_options)
    end

    private

    def glob
      config_linter[:glob] || config_linter.dig(:options, :glob) || DEFAULT_GLOB
    end

    def stylelint_config
      stylelintrc = config_linter[:config] || config_linter.dig(:options, :config)
      "--config=#{stylelintrc}" if stylelintrc
    end

    def syntax
      syntax = config_linter[:syntax] || config_linter.dig(:options, :syntax)
      "--syntax=#{syntax}" if syntax
    end

    def ignore_path
      ignore_path = config_linter[:'ignore-path'] || config_linter.dig(:options, :'ignore-path')
      "--ignore-path=#{ignore_path}" if ignore_path
    end

    def ignore_disables
      ignore_disables = config_linter[:'ignore-disables'] || config_linter.dig(:options, :'ignore-disables')
      "--ignore-disables" if ignore_disables
    end

    def report_needless_disables
      rd = config_linter[:'report-needless-disables'] || config_linter.dig(:options, :'report-needless-disables')
      "--report-needless-disables" if rd
    end

    def quiet
      quiet = config_linter[:quiet] || config_linter.dig(:options, :quiet)
      "--quiet" if quiet
    end

    # @param stdout [String]
    def parse_result(stdout)
      JSON.parse(stdout, symbolize_names: true).flat_map do |file|
        check_warning(file[:deprecations])
        path = relative_path(file[:source])

        file[:warnings].map do |warning|
          line = warning[:line]
          id = warning[:rule]

          Issue.new(
            path: path,
            location: line ? Location.new(start_line: line, start_column: warning[:column]) : nil, # NOTE: There is a rare case that stylelint doesn't output the `line`.
            id: id,
            message: normalize_message(id, warning[:text]),
            links: [rule_doc_urls[id]].compact,
            object: {
              severity: warning[:severity],
            },
            schema: Schema.issue,
          )
        end
      end
    end

    # @see https://github.com/stylelint/stylelint/blob/11.1.1/lib/formatters/stringFormatter.js#L120
    def normalize_message(id, message)
      message.delete_suffix("(#{id})").strip # trim ID
    end

    # @see https://github.com/stylelint/stylelint/blob/11.1.1/lib/formatters/stringFormatter.js#L120
    def rule_doc_urls
      @rule_doc_urls ||=
        begin
          # Find stylelint installed location.
          stdout, _, status = capture3 "node", "-pe", "require.resolve('stylelint')"
          if status.success?
            Pathname.glob(stdout.chomp.sub("/lib/index.js", "/lib/rules/*"))
              .filter(&:directory?)
              .each_with_object({}) do |dir, hash|
                rule = dir.basename.to_s
                hash[rule] = "https://github.com/stylelint/stylelint/tree/#{analyzer_version}/lib/rules/#{rule}"
              end
          else
            {}
          end
        end
    end

    def prepare_config_file
      return if config_file_path

      # NOTE: `stylelint-config-recommended@2` does not work with `stylelint@11`.
      src = if Gem::Version.create(analyzer_version) >= Gem::Version.create("11.0.0")
              (Pathname(Dir.home) / 'sider_recommended_config.yaml').realpath
            else
              (Pathname(Dir.home) / 'sider_recommended_config.old.yaml').realpath
            end
      dst = current_dir.join('.stylelintrc.yaml')
      FileUtils.copy(src, dst)
    end

    def prepare_ignore_file
      ignore_file_path = current_dir.join('.stylelintignore')
      return if ignore_file_path.file?
      src = (Pathname(Dir.home) / 'sider_recommended_stylelintignore').realpath
      FileUtils.copy(src, ignore_file_path)
    end

    # returns available config file path. If the file doesn't exist, it returns nil.
    def config_file_path
      config_path = config_linter[:config] || config_linter.dig(:options, :config)
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

    # Save warnings written by stylelint.
    # stylelint writes "deprecations" flags in each file, so we cannot conduct naive implementations.
    # Without this method, if we write a warning when the "deprecations" appear,
    # the same number of duplicated warnings as files will appear.
    # We use `Set` to avoid it.
    #
    # @param deprecations [Array<Hash>]
    def check_warning(deprecations)
      @warning_set ||= Set.new
      deprecations.each do |dep|
        @warning_set << "#{dep[:text]} #{dep[:reference]}"
      end
    end

    def run_analyzer(glob, additional_options)
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
      if Gem::Version.new(analyzer_version) >= Gem::Version.new("10.0.1")
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
        return Results::Failure.new(guid: guid, message: [stdout, stderr].join("\n"), analyzer: analyzer)
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        parse_result(stdout).each { |v| result.add_issue(v) }
        @warning_set&.sort&.each do |warning|
          add_warning(warning, file: config_file_path&.to_s)
        end
      end
    end
  end
end
