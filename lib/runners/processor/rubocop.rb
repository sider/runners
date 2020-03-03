module Runners
  class Processor::RuboCop < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.ruby.update_fields { |fields|
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

      let :issue, object(
        severity: string?,
        corrected: boolean?,
      )
    end

    register_config_schema(name: :rubocop, schema: Schema.runner_config)

    # The followings are maintained by RuboCop Headquarters.
    # @see https://github.com/rubocop-hq
    OFFICIAL_RUBOCOP_PLUGINS = [
      GemInstaller::Spec.new(name: "rubocop-md", version: []),
      GemInstaller::Spec.new(name: "rubocop-minitest", version: []),
      GemInstaller::Spec.new(name: "rubocop-performance", version: []),
      GemInstaller::Spec.new(name: "rubocop-rails", version: []),
      GemInstaller::Spec.new(name: "rubocop-rake", version: []),
      GemInstaller::Spec.new(name: "rubocop-rspec", version: []),
      GemInstaller::Spec.new(name: "rubocop-rubycw", version: []),
      GemInstaller::Spec.new(name: "rubocop-sequel", version: []),
    ].freeze

    # @see https://help.sider.review/tools/ruby/rubocop#gems
    OPTIONAL_GEMS = [
      *OFFICIAL_RUBOCOP_PLUGINS,
      GemInstaller::Spec.new(name: "cookstyle", version: []),
      GemInstaller::Spec.new(name: "deka_eiwakun", version: []),
      GemInstaller::Spec.new(name: "ezcater_rubocop", version: []),
      GemInstaller::Spec.new(name: "fincop", version: []),
      GemInstaller::Spec.new(name: "forkwell_cop", version: []),
      GemInstaller::Spec.new(name: "gc_ruboconfig", version: []),
      GemInstaller::Spec.new(name: "gitlab-styles", version: []),
      GemInstaller::Spec.new(name: "hint-rubocop_style", version: []),
      GemInstaller::Spec.new(name: "mad_rubocop", version: []),
      GemInstaller::Spec.new(name: "meowcop", version: []),
      GemInstaller::Spec.new(name: "onkcop", version: []),
      GemInstaller::Spec.new(name: "otacop", version: []),
      GemInstaller::Spec.new(name: "pulis", version: []),
      GemInstaller::Spec.new(name: "rubocop-cask", version: []),
      GemInstaller::Spec.new(name: "rubocop-config-umbrellio", version: []),
      GemInstaller::Spec.new(name: "rubocop-github", version: []),
      GemInstaller::Spec.new(name: "rubocop-rails_config", version: []),
      GemInstaller::Spec.new(name: "rubocop-salemove", version: []),
      GemInstaller::Spec.new(name: "rubocop-thread_safety", version: []),
      GemInstaller::Spec.new(name: "salsify_rubocop", version: []),
      GemInstaller::Spec.new(name: "sanelint", version: []),
      GemInstaller::Spec.new(name: "unasukecop", version: []),
      GemInstaller::Spec.new(name: "unifacop", version: []),
      GemInstaller::Spec.new(name: "ws-style", version: []),
    ].freeze

    CONSTRAINTS = {
      "rubocop" => [">= 0.61.0", "< 1.0.0"]
    }.freeze

    def default_gem_specs
      super.tap do |gems|
        if setup_default_config
          # NOTE: The latest MeowCop requires usually the latest RuboCop.
          #       (e.g. MeowCop 2.4.0 requires RuboCop 0.75.0+)
          #       So, MeowCop versions must be unspecified because the installation will fail when a user's RuboCop is 0.60.0.
          #       Bundler will select an appropriate version automatically unless versions.
          gems << GemInstaller::Spec.new(name: "meowcop", version: [])
        end
      end
    end

    def setup
      add_warning_if_deprecated_options([:options])

      install_gems default_gem_specs, optionals: OPTIONAL_GEMS, constraints: CONSTRAINTS do
        analyzer
        yield
      end
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(_)
      options = ["--display-style-guide", "--cache=false", "--no-display-cop-names", rails_option, config_file, safe].compact
      run_analyzer(options)
    end

    private

    def rails_option
      rails = config_linter[:rails]
      rails = config_linter.dig(:options, :rails) if rails.nil?
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

    def config_file
      config_path = config_linter[:config] || config_linter.dig(:options, :config)
      "--config=#{config_path}" if config_path
    end

    def safe
      "--safe" if config_linter[:safe]
    end

    def setup_default_config
      path = current_dir / ".rubocop.yml"
      return false if path.exist?

      path.parent.mkpath
      FileUtils.cp (Pathname(Dir.home) / "default_rubocop.yml"), path
      trace_writer.message "Setup the default RuboCop configuration file."
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
      output_file = Tempfile.new("rubocop-")

      # NOTE: `--out` option must be after `--format` option.
      #
      # @see https://docs.rubocop.org/en/stable/formatters
      options << "--format=json"
      options << "--out=#{output_file.path}"

      _, stderr, status = capture3(*ruby_analyzer_bin, *options)
      check_rubocop_yml_warning(stderr)

      # 0: no offences
      # 1: offences exist
      # 2: RuboCop crashes by unhandled errors.
      unless [0, 1].include?(status.exitstatus)
        error_message = stderr.strip
        if error_message.empty?
          error_message = "RuboCop raised an unexpected error. See the analysis log for details."
        end
        return Results::Failure.new(guid: guid, message: error_message, analyzer: analyzer)
      end

      output_json = output_file.read
      unless output_json.empty?
        trace_writer.message "Output JSON: #{output_json}"
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        break result if output_json == '' # No offenses

        JSON.parse(output_json, symbolize_names: true)[:files].reject { |v| v[:offenses].empty? }.each do |hash|
          hash[:offenses].each do |offense|
            loc = Location.new(
              start_line: offense[:location][:line],
              start_column: offense[:location][:column],
              end_line: offense[:location][:last_line] || offense[:location][:line],
              end_column: offense[:location][:last_column] || offense[:location][:column]
            )
            links = extract_links(offense[:message])
            result.add_issue Issue.new(
              path: relative_path(hash[:path]),
              location: loc,
              id: offense[:cop_name],
              message: normalize_message(offense[:message], links, offense[:cop_name]),
              links: links + build_cop_links(offense[:cop_name]),
              object: {
                severity: offense[:severity],
                corrected: offense[:corrected],
              },
              schema: Schema.issue,
            )
          end
        end
      end
    end

    # @see https://github.com/rubocop-hq/rubocop/blob/v0.76.0/lib/rubocop/cop/message_annotator.rb#L62-L63
    def extract_links(original_message)
      URI.extract(original_message, %w(http https))
        .map { |uri| uri.delete_suffix(",").delete_suffix(")") }
    end

    def build_cop_links(cop_name)
      department, cop = cop_name.split("/").map(&:downcase)

      if department && cop
        fragment = "#{department}#{cop}"
        case
        when core_departments.include?(department)
          return ["https://github.com/rubocop-hq/rubocop/blob/v#{analyzer_version}/manual/cops_#{department}.md##{fragment}"]
        when ["rails", "performance"].include?(department)
          version = rubocop_plugin_version("rubocop-#{department}")
          if version
            return ["https://github.com/rubocop-hq/rubocop-#{department}/blob/v#{version}/manual/cops_#{department}.md##{fragment}"]
          end
        end
      end

      []
    end

    def core_departments
      @core_departments ||= %w[style layout lint metrics naming security bundler gemspec].tap do |list|
        list << "rails" unless rails_cops_removed?
        list << "performance" unless performance_cops_removed?
      end
    end

    def rubocop_plugin_version(gem_name)
      @rubocop_plugin_versions ||= installed_gem_versions("rubocop-rails", "rubocop-performance", exception: false)
      @rubocop_plugin_versions[gem_name]&.first
    end

    def normalize_message(original_message, links, cop_name)
      original_message.delete_suffix("(" + links.join(", ") + ")").strip
    end

    # @see https://github.com/rubocop-hq/rubocop/blob/v0.72.0/CHANGELOG.md
    def rails_cops_removed?
      Gem::Version.create(analyzer_version) >= Gem::Version.create("0.72.0")
    end

    # @see https://github.com/rubocop-hq/rubocop/blob/v0.68.0/CHANGELOG.md
    def performance_cops_removed?
      Gem::Version.create(analyzer_version) >= Gem::Version.create("0.68.0")
    end
  end
end
