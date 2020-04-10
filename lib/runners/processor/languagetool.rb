module Runners
  class Processor::LanguageTool < Processor
    include Java

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!(
          target: string?,
          language: string?,
          encoding: string?,
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

    DEFAULT_FILE_PATTERN = "*.{txt,md,markdown}".freeze
    DEFAULT_TARGET = ".".freeze
    DEFAULT_LANGUAGE = "en-US".freeze # NOTE: Specify a variant for spell checking
    DEFAULT_ENCODING = "UTF-8".freeze

    def analyze(changes)
      delete_all_files_except(DEFAULT_FILE_PATTERN)
      run_analyzer
    end

    private

    def delete_all_files_except(pattern)
      trace_writer.message "Deleting all files except #{pattern}..." do
        count = current_dir.glob("**/*", File::FNM_DOTMATCH)
          .filter(&:file?)
          .reject { |path| path.fnmatch?(pattern, File::FNM_EXTGLOB) }
          .each(&:delete)
          .count
        trace_writer.message "#{count} files deleted"
      end
    end

    def config_language
      config_linter[:language] || DEFAULT_LANGUAGE
    end

    def config_encoding
      Encoding.find(config_linter[:encoding] || DEFAULT_ENCODING)
    end

    def cli_args
      [
        "--json",
        "--recursive",
        "--language", config_language,
        "--encoding", config_encoding.to_s,
        config_linter[:target] || DEFAULT_TARGET,
      ]
    end

    def run_analyzer
      stdout_and_stderr, = capture3!(analyzer_bin, *cli_args, merge_output: true)

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
                category: match.dig(:rule, :category, :name),
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
        s.scan_until(/Working on (.+)\.\.\./)
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
