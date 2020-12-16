module Runners
  class Processor::LanguageTool < Processor
    include Java

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!(
          target: string?,
          ext: array?(string),
          exclude: array?(string),
          language: string?,
          encoding: string?,
          disable: array?(string),
          enable: array?(string),
          enabledonly: boolean?,
          disablecategories: array?(string),
          enablecategories: array?(string),
        )
      }

      let :issue, object(
        sentence: string,
        type: string,
        category: string,
        replacements: array(string),
      )
    end

    register_config_schema(name: :languagetool, schema: Schema.runner_config)

    DEFAULT_TARGET = ".".freeze
    DEFAULT_EXT = [".txt"].freeze
    DEFAULT_EXCLUDE = ["**/{requirements,robots}.txt"].freeze
    DEFAULT_LANGUAGE = "en-US".freeze # NOTE: Need a variant for spell checking
    DEFAULT_ENCODING = "UTF-8".freeze
    DEFAULT_DISABLE = [].freeze
    DEFAULT_ENABLE = [].freeze
    DEFAULT_DISABLECATEGORIES = [].freeze
    DEFAULT_ENABLECATEGORIES = [].freeze

    def analyze(changes)
      delete_files_except_targets
      delete_unchanged_files(changes)
      run_analyzer
    end

    private

    def delete_files_except_targets
      target_pattern = "*.{" + config_ext.join(",") + "}"
      excludes = config_exclude

      trace_writer.message "Deleting files not to be analyzed..." do
        count = current_dir.glob("**/*", File::FNM_DOTMATCH)
          .filter(&:file?)
          .filter do |path|
            if excludes.any? { |ex| path.fnmatch?(ex, File::FNM_EXTGLOB) }
              true
            else
              !path.fnmatch?(target_pattern, File::FNM_EXTGLOB)
            end
          end
          .each(&:delete)
          .count
        trace_writer.message "#{count} files deleted"
      end
    end

    def config_target
      config_linter[:target] || DEFAULT_TARGET
    end

    def config_ext
      (config_linter[:ext] || DEFAULT_EXT).map { |ext| ext.delete_prefix(".") }
    end

    def config_exclude
      config_linter[:exclude] || DEFAULT_EXCLUDE
    end

    def config_language
      config_linter[:language] || DEFAULT_LANGUAGE
    end

    def config_encoding
      @config_encoding ||= Encoding.find(config_linter[:encoding] || DEFAULT_ENCODING).name
    end

    def cli_comma_separated_list(config_option, default_value, cli_option)
      value = comma_separated_list(config_linter[config_option] || default_value)
      value ? [cli_option, value] : []
    end

    def cli_disable
      cli_comma_separated_list :disable, DEFAULT_DISABLE, "--disable"
    end

    def cli_enable
      cli_comma_separated_list :enable, DEFAULT_ENABLE, "--enable"
    end

    def cli_enabledonly
      config_linter[:enabledonly] ? ["--enabledonly"] : []
    end

    def cli_disablecategories
      cli_comma_separated_list :disablecategories, DEFAULT_DISABLECATEGORIES, "--disablecategories"
    end

    def cli_enablecategories
      cli_comma_separated_list :enablecategories, DEFAULT_ENABLECATEGORIES, "--enablecategories"
    end

    def cli_args
      [
        "--json",
        "--recursive",
        "--language", config_language,
        "--encoding", config_encoding,
        *cli_disable,
        *cli_enable,
        *cli_enabledonly,
        *cli_disablecategories,
        *cli_enablecategories,
        config_target,
      ]
    end

    def run_analyzer
      begin
        stdout_and_stderr, _status = capture3!(analyzer_bin, *cli_args, merge_output: true)
      rescue Shell::ExecError => error
        error.stdout_str.match(/\bjava\.lang\.IllegalArgumentException: (.+)$/) do |m|
          msg = m.captures.first or raise "Invalid match data: #{m.inspect}"
          msg << "\nPlease check your `#{config.path_name}`" if config.path_name
          return Results::Failure.new(guid: guid, analyzer: analyzer, message: msg)
        end

        raise
      end

      raise "stdout and stderr must not be empty" unless stdout_and_stderr

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        parse_output(stdout_and_stderr) do |filepath, data|
          matches = data.fetch(:matches)
          next if matches.empty?

          # NOTE: Line numbers are not output to JSON, so we need to calculate them by ourselves.
          offset_ranges = offset_ranges_per_line(File.readlines(filepath, encoding: config_encoding))
          relative_file = relative_path(filepath)

          matches.each do |match|
            offset = Integer(match.fetch(:offset))
            line_index = offset_ranges.find_index { |range| range.include?(offset) } or
              raise "Not found line number from the offset #{offset}: ranges=#{offset_ranges}, file=#{relative_file}"

            result.add_issue Issue.new(
              path: relative_file,
              location: Location.new(start_line: line_index + 1),
              id: match.dig(:rule, :id),
              message: match[:message],
              object: {
                sentence: match[:sentence],
                type: match.dig(:rule, :issueType),
                category: match.dig(:rule, :category, :id),
                replacements: match[:replacements]&.map { |r| r[:value] },
              },
              schema: Schema.issue,
            )
          end
        end
      end
    end

    def parse_output(output)
      s = StringScanner.new(output)
      until s.eos?
        s.scan_until(/Working on (.+)\.\.\./) or return # no target files
        file = s.captures.first
        json = s.scan_until(/\{.+\}/)
        data = JSON.parse(json, symbolize_names: true)
        yield file, data
      end
    end

    def offset_ranges_per_line(lines)
      start = 0
      lines.map do |line|
        last = start + line.size
        (start...last).tap { start = last }
      end
    end
  end
end
