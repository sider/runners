module Runners
  class Processor::RuboCop < Processor
    include Ruby
    include RuboCopUtils

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, ruby(
        config: string?,
        rails: boolean?,
        safe: boolean?,
      )

      let :issue, object(
        severity: string?,
        corrected: boolean?,
      )
    end

    register_config_schema SCHEMA.config

    GEM_NAME = "rubocop".freeze
    CONSTRAINTS = {
      GEM_NAME => Gem::Requirement.new(">= 0.61.0", "< 2.0.0").freeze,
    }.freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        gems:
          - rubocop-rails
          - { name: rubocop-rspec, version: 2.1.0 }
        config: config/.rubocop.yml
        safe: true
      YAML
    end

    def setup
      default_gems = default_gem_specs(GEM_NAME)
      if !rubocop_config_file && setup_default_rubocop_config
        # NOTE: The latest MeowCop requires usually the latest RuboCop.
        #       (e.g. MeowCop 2.4.0 requires RuboCop 0.75.0+)
        #       So, MeowCop versions must be unspecified because the installation will fail when a user's RuboCop is 0.60.0.
        #       Bundler will select an appropriate version automatically unless versions.
        default_gems << GemInstaller::Spec.new("meowcop")
      end

      optionals = official_rubocop_plugins + third_party_rubocop_plugins
      install_gems(default_gems, optionals: optionals, constraints: CONSTRAINTS) { yield }
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(_changes)
      cmd = ruby_analyzer_command(
        "--display-style-guide",
        "--no-display-cop-names",

        # NOTE: `--parallel` requires a cache.
        #
        # @see https://github.com/rubocop/rubocop/blob/v1.3.1/lib/rubocop/options.rb#L353-L355
        "--parallel",
        "--cache=true",
        *cache_root,

        # NOTE: `--out` option must be after `--format` option.
        #
        # @see https://docs.rubocop.org/rubocop/1.3/formatters.html
        "--format=json",
        "--out=#{report_file}",

        *rails_option,
        *rubocop_config_file_option,
        *safe,
      )

      _, stderr, status = capture3(cmd.bin, *cmd.args)
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

      output_json = read_report_json { nil }

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        break result unless output_json # No offenses

        output_json.fetch(:files).reject { |v| v[:offenses].empty? }.each do |hash|
          hash[:offenses].each do |offense|
            loc = Location.new(
              start_line: offense[:location][:line],
              start_column: offense[:location][:column],
              end_line: offense[:location][:last_line] || offense[:location][:line],
              end_column: offense[:location][:last_column] || offense[:location][:column]
            )
            links = extract_urls(offense[:message])
            result.add_issue Issue.new(
              path: relative_path(hash[:path]),
              location: loc,
              id: offense[:cop_name],
              message: normalize_message(offense[:message], links, offense[:cop_name]),
              links: links + build_rubocop_links(offense[:cop_name]),
              object: {
                severity: offense[:severity],
                corrected: offense[:corrected],
              },
              schema: SCHEMA.issue,
            )
          end
        end
      end
    end

    private

    def rails_option
      rails = config_linter[:rails]
      case
      when rails && !rails_cops_removed?
        ['--rails']
      when rails && rails_cops_removed?
        add_warning <<~WARNING, file: config.path_name
          The `#{config_field_path(:rails)}` option in your `#{config.path_name}` is ignored.
          Because the `--rails` option was removed from RuboCop 0.72. Use the `rubocop-rails` gem instead.
        WARNING
        []
      when rails == false
        []
      when rails_cops_removed?
        []
      when %w[bin/rails script/rails].any? { |path| current_dir.join(path).exist? }
        ['--rails']
      else
        []
      end
    end

    def rubocop_config_file
      config_linter[:config]
    end

    def rubocop_config_file_option
      rubocop_config_file.then { |path| path ? ["--config=#{path}"] : [] }
    end

    def safe
      config_linter[:safe] ? ["--safe"] : []
    end

    def check_rubocop_yml_warning(stderr)
      patterns = [
        # @see https://github.com/rubocop/rubocop/blob/v0.89.1/lib/rubocop/cop/registry.rb#L263
        /(?<file>.+): .+ has the wrong namespace/,

        # @see https://github.com/rubocop/rubocop/blob/v0.71.0/lib/rubocop/runner.rb#L30
        /Rails cops will be removed from RuboCop 0.72/,

        # @see https://github.com/rubocop/rubocop/blob/v0.89.1/lib/rubocop/cop/team.rb#L244
        /An error occurred while .+ inspecting (?<file>.+):.+:/,
      ]

      warnings = []

      stderr.each_line(chomp: true) do |message|
        patterns.each do |pattern|
          message.match(pattern) do |match|
            file = match.named_captures["file"]
            if file
              rel_file = relative_path(file).to_path
              message.sub!(file, rel_file)
              file = rel_file
            end
            warnings << [message, file]
          end
        end
      end

      warnings.uniq!
      warnings.sort_by! { |_, file| file ? file : "" } # 1. no file, 2. filename
      warnings.each { |msg, file| add_warning(msg, file: file) }
    end

    def normalize_message(original_message, links, cop_name)
      original_message.delete_suffix("(" + links.join(", ") + ")").strip
    end

    # @see https://github.com/rubocop/rubocop/blob/v0.72.0/CHANGELOG.md
    def rails_cops_removed?
      Gem::Version.new(analyzer_version) >= Gem::Version.new("0.72.0")
    end

    def cache_root
      # @see https://github.com/rubocop/rubocop/blob/v0.91.0/CHANGELOG.md
      if Gem::Version.new(analyzer_version) >= Gem::Version.new("0.91.0")
        ["--cache-root=#{File.join(Dir.tmpdir, 'rubocop-cache')}"]
      else
        []
      end
    end
  end
end
