module NodeHarness
  module Runners
    module RuboCop
      class Processor < NodeHarness::Processor
        include NodeHarness::Ruby

        attr_reader :analyzer

        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.ruby.update_fields { |fields|
            fields.merge!({
                            config: string?,
                            rails: boolean?,
                            safe: boolean?,
                            # DO NOT ADD OPTIONS ANY MORE in `options`.
                            options: optional(object(
                                                config: string?,
                                                rails: boolean?
                                              ))
                          })
          }
        end

        DefaultConfig = <<~YAML.freeze
          inherit_gem:
            meowcop:
              - config/rubocop.yml
        YAML

        DEFAULT_GEMS = [
          GemInstaller::Spec.new(name: "rubocop", version: ["0.74.0"]),
        ].freeze

        # DEPRECATED: Implicit dependencies
        # @see https://help.sider.review/tools/ruby/rubocop#gems
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
          "rubocop" => [">= 0.35.0"]
        }.freeze

        def self.ci_config_section_name
          'rubocop'
        end

        def setup
          ensure_runner_config_schema(Schema.runner_config) do
            defaults = DEFAULT_GEMS

            if setup_default_config
              defaults = defaults + [GemInstaller::Spec.new(name: "meowcop", version: [])]
            end

            install_gems defaults, optionals: OPTIONAL_GEMS, constraints: CONSTRAINTS do |versions|
              @analyzer = NodeHarness::Analyzer.new(name: 'RuboCop', version: versions.fetch("rubocop"))
              yield
            end
          end
        rescue InstallGemsFailure => exn
          trace_writer.error exn.message
          return NodeHarness::Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
        end

        def analyze(_)
          # TODO: Remove duplicated `ensure_runner_config_schema` method call
          ensure_runner_config_schema(Schema.runner_config) do |config|
            check_runner_config(config) do |options|
              run_analyzer(options)
            end
          end
        end

        private

        def check_runner_config(config)
          opts = %w[
            --display-style-guide
            --display-cop-names
            --cache=false
            --format=json
          ]

          # Additional Options
          rails_option(config).tap { |opt| opts << opt if opt }
          config_file(config).tap { |opt| opts << opt if opt }
          safe(config).tap { |opt| opts << opt if opt }

          yield opts
        end

        def rails_option(config)
          rails = config[:rails]
          rails = config.dig(:options, :rails) if rails.nil?
          case
          when rails && !rails_cops_removed?
            '--rails'
          when rails && rails_cops_removed?
            add_warning(<<~WARNING, file: "sideci.yml")
              `rails` option is ignored because the option was removed from RuboCop 0.72. Use the `rubocop-rails` gem instead.
              See https://help.sider.review/getting-started/custom-configuration#gems-option
            WARNING
            nil
          when rails == false
            nil
          when rails_cops_removed?
            nil
          when %w[bin/rails script/rails].any? { |path| current_dir.join(path).exist? }
            '--rails'
          end
        end

        def config_file(config)
          config_path = config[:config] || config.dig(:options, :config)
          "--config=#{config_path}" if config_path
        end

        def safe(config)
          "--safe" if config[:safe]
        end

        def setup_default_config
          path = Pathname("#{current_dir}/.rubocop.yml")
          return false if path.exist?
          path.parent.mkpath
          File.write(path, DefaultConfig)
          true
        end

        def check_rubocop_yml_warning(stderr)
          error_occurred = false
          stderr.each_line do |line|
            case line
            when /(.+): (.+has the wrong namespace - should be.+$)/
              file = $1
              msg = $2
              add_warning(msg, file: relative_path(file).to_s)
            when /Rails cops will be removed from RuboCop 0.72/
              add_warning(<<~WARNING)
                Rails cops will be removed from RuboCop 0.72. Use the `rubocop-rails` gem instead.
                https://github.com/rubocop-hq/rubocop/blob/master/manual/migrate_rails_cops.md
                https://help.sider.review/getting-started/custom-configuration#gems-option
              WARNING
            when /^\d+ errors? occurred:$/
              # NOTE: "An error occurred... is displayed twice, "when an error happens", and "at the end of RuboCop runtime".
              #       So, we handle "at the end of RuboCop runtime" only.
              error_occurred = true
            when /^(An error occurred while \S+ cop) was inspecting (.+):\d+:\d+\.$/
              next unless error_occurred
              file = $2
              msg = $1
              add_warning("RuboCop crashes: #{msg}", file: relative_path(file).to_s)
            end
          end
        end

        def run_analyzer(options)
          stdout, stderr, status = capture3(
            'bundle',
            'exec',
            'rubocop',
            *options
          )
          check_rubocop_yml_warning(stderr)
          # 0: no offences
          # 1: offences exist
          # 2: RuboCop crashes by unhandled errors.
          unless [0, 1].include?(status.exitstatus)
            return NodeHarness::Results::Failure.new(guid: guid, message: <<~TEXT, analyzer: analyzer)
              RuboCop exits with unexpected status #{status.exitstatus}.
              STDOUT:
              #{stdout}
              STDERR:
              #{stderr}
            TEXT
          end

          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            break result if stdout == '' # No offenses

            JSON.parse(stdout, symbolize_names: true)[:files].reject { |v| v[:offenses].empty? }.each do |hash|
              hash[:offenses].each do |offense|
                loc = NodeHarness::Location.new(
                  start_line: offense[:location][:line],
                  start_column: offense[:location][:column],
                  end_line: offense[:location][:last_line] || offense[:location][:line],
                  end_column: offense[:location][:last_column] || offense[:location][:column]
                )
                links = URI.extract(offense[:message], %w(http https)).map { |v| v.sub(/[,\)]+$/, '') }
                message = links
                            .inject(offense[:message]) { |msg, link| msg.sub(link, '') }
                            .sub(/\s*\((, )?\)\z/, '')
                result.add_issue NodeHarness::Issues::Text.new(
                  path: relative_path(hash[:path]),
                  location: loc,
                  id: offense[:cop_name],
                  message: message,
                  links: links,
                )
              end
            end
          end
        end

        def rails_cops_removed?
          Gem::Version.new(analyzer.version) >= Gem::Version.new("0.72.0")
        end
      end
    end
  end
end
