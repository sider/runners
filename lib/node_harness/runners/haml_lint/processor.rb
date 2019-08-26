module NodeHarness
  module Runners
    module HamlLint
      class Processor < NodeHarness::Processor
        include NodeHarness::Ruby

        attr_reader :analyzer

        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.ruby.update_fields { |fields|
            fields.merge!({
                            file: string?,
                            include_linter: enum?(string, array(string)),
                            exclude_linter: enum?(string, array(string)),
                            exclude: enum?(string, array(string)),
                            config: string?,
                            # DO NOT ADD ANY OPTION in `options` option.
                            options: object?(
                              file: string?,
                              include_linter: enum?(string, array(string)),
                              exclude_linter: enum?(string, array(string)),
                              exclude: enum?(string, array(string)),
                              config: string?
                            )
                          })
          }
        end

        DEFAULT_GEMS = [
          GemInstaller::Spec.new(name: "haml_lint", version: ["0.32.0"]),
        ].freeze

        # DEPRECATED: Implicit dependencies
        # @see https://github.com/sider/runner_rubocop/blob/3.1.0/lib/entrypoint.rb#L27-L52
        OPTIONAL_GEMS = [
          GemInstaller::Spec.new(name: "meowcop", version: []),
          GemInstaller::Spec.new(name: "onkcop", version: []),
          GemInstaller::Spec.new(name: "deka_eiwakun", version: []),
          GemInstaller::Spec.new(name: "forkwell_cop", version: []),
          GemInstaller::Spec.new(name: "cookstyle", version: []),
          GemInstaller::Spec.new(name: "rubocop-rails_config", version: []),
          GemInstaller::Spec.new(name: "salsify_rubocop", version: []),
          GemInstaller::Spec.new(name: "otacop", version: []),
          GemInstaller::Spec.new(name: "unasukecop", version: []),
          GemInstaller::Spec.new(name: "sanelint", version: []),
          GemInstaller::Spec.new(name: "hint-rubocop_style", version: []),
          GemInstaller::Spec.new(name: "rubocop-salemove", version: []),
          GemInstaller::Spec.new(name: "mad_rubocop", version: []),
          GemInstaller::Spec.new(name: "unifacop", version: []),
          GemInstaller::Spec.new(name: "ws-style", version: []),
          GemInstaller::Spec.new(name: "rubocop-config-umbrellio", version: []),
          GemInstaller::Spec.new(name: "pulis", version: []),
          GemInstaller::Spec.new(name: "gc_ruboconfig", version: []),
          GemInstaller::Spec.new(name: "fincop", version: []),
          GemInstaller::Spec.new(name: "rubocop-github", version: []),
          GemInstaller::Spec.new(name: "ezcater_rubocop", version: []),
          GemInstaller::Spec.new(name: "rubocop-rspec", version: []),
          GemInstaller::Spec.new(name: "rubocop-cask", version: []),
          GemInstaller::Spec.new(name: "rubocop-thread_safety", version: []),
        ].freeze

        CONSTRAINTS = {
          "haml_lint" => [">= 0.26.0"]
        }.freeze

        def self.ci_config_section_name
          'haml_lint'
        end

        def setup
          ensure_runner_config_schema(Schema.runner_config) do
            defaults = DEFAULT_GEMS

            if setup_default_config
              defaults = defaults + [GemInstaller::Spec.new(name: "meowcop", version: [])]
            end

            install_gems defaults, optionals: OPTIONAL_GEMS, constraints: CONSTRAINTS do |versions|
              @analyzer = NodeHarness::Analyzer.new(name: 'haml_lint', version: versions.fetch("haml_lint"))
              yield
            end
          end
        rescue InstallGemsFailure => exn
          trace_writer.error exn.message
          return NodeHarness::Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
        end

        def analyze(_changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            check_runner_config(config) do |targets, options|
              run_analyzer(targets, options)
            end
          end
        end

        def setup_default_config
          # NOTE: We expect default_rubocop.yml to be located in $HOME.
          default_config = (Pathname(Dir.home) / './default_rubocop.yml').realpath
          path = Pathname("#{current_dir}/.rubocop.yml")
          return false if path.exist?
          path.parent.mkpath
          FileUtils.cp(default_config, path)
          true
        end

        def check_runner_config(config)
          # Option which has a default value.
          targets = file(config)

          # Additional option.
          options = []
          include_linter(config).tap { |opt| options << opt if opt }
          exclude_linter(config).tap { |opt| options << opt if opt }
          exclude(config).tap { |opt| options << opt if opt }
          haml_lint_config(config).tap { |opt| options << opt if opt }

          yield targets, options
        end

        def file(config)
          config[:file] || config.dig(:options, :file) || '.'
        end

        def include_linter(config)
          include_linter = config[:include_linter] || config.dig(:options, :include_linter)
          if include_linter
            "--include-linter=#{Array(include_linter).join(',')}"
          end
        end

        def exclude_linter(config)
          exclude_linter = config[:exclude_linter] || config.dig(:options, :exclude_linter)
          if exclude_linter
            "--exclude-linter=#{Array(exclude_linter).join(',')}"
          end
        end

        def exclude(config)
          exclude = config[:exclude] || config.dig(:options, :exclude)
          if exclude
            "--exclude=#{Array(exclude).join(',')}"
          end
        end

        def haml_lint_config(config)
          config = config[:config] || config.dig(:options, :config)
          "--config=#{config}" if config
        end

        def parse_result(stdout)
          JSON.parse(stdout)['files'].flat_map do |file|
            path = file['path']
            file['offenses'].map do |offense|
              id = offense['linter_name']
              message = offense['message']
              line = offense['location']['line']

              loc = NodeHarness::Location.new(
                start_line: line,
                start_column: nil,
                end_line: nil,
                end_column: nil
              )
              NodeHarness::Issues::Text.new(
                path: relative_path(path),
                location: loc,
                id: id,
                message: message,
                links: []
              )
            end
          end
        end

        def run_analyzer(targets, options)
          stdout, stderr, status = capture3(
            'bundle',
            'exec',
            'haml-lint',
            targets,
            '--reporter',
            'json',
            *options,
          )
          unless [Sysexits::EX_DATAERR, Sysexits::EX_OK].include?(status.exitstatus)
            return NodeHarness::Results::Failure.new(guid: guid, message: <<~MESSAGE, analyzer: analyzer)
              stdout:
              #{stdout}

              stderr:
              #{stderr}
            MESSAGE
          end

          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            parse_result(stdout).each { |v| result.add_issue(v) }
          end
        end
      end
    end
  end
end
