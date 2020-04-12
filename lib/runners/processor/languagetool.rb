module Runners
  class Processor::LanguageTool < Processor
    include Java

    # NOTE: See `pandoc --list-input-formats`
    SUPPORTED_FILES = {
      # Plain text
      "txt" => { pandoc: "plain" },

      # Markdown
      "md" => { pandoc: "commonmark" },
      "markdown" => { pandoc: "commonmark" },

      # reStructuredText
      "rst" => { pandoc: "rst" },

      # TeX
      "tex" => { pandoc: "latex" },

      # HTML
      "html" => { pandoc: "html" },
    }.freeze

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!(
          target: string?,
          ext: array?(enum(SUPPORTED_FILES.keys.map { |ext| literal(ext) })),
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

    DEFAULT_TARGET = ".".freeze
    DEFAULT_EXT = SUPPORTED_FILES.keys.freeze
    DEFAULT_LANGUAGE = "en-US".freeze # NOTE: Specify a variant for spell checking
    DEFAULT_ENCODING = "UTF-8".freeze

    def analyze(changes)
      delete_all_files_except("*.{#{config_ext.join(',')}}")
      delete_unchanged_files(changes)
      convert_to_plain_text(config_ext - ["txt"])
      run_analyzer
    end

    private

    def all_files
      @all_files ||= current_dir.glob("**/*", File::FNM_DOTMATCH).filter(&:file?)
    end

    def delete_all_files_except(pattern)
      trace_writer.message "Deleting all files except #{pattern}..." do
        count = all_files
          .reject { |path| path.fnmatch?(pattern, File::FNM_EXTGLOB) }
          .each(&:delete)
          .count
        trace_writer.message "#{count} files deleted"
      end
    end

    def convert_to_plain_text(extensions)
      trace_writer.message "Converting \"#{extensions.join(',')}\" files to plain text..." do
        extensions.each do |ext|
          input_format = SUPPORTED_FILES.fetch(ext).fetch(:pandoc)
          all_files.filter { |path| path.extname == ".#{ext}" }.each do |path|
            file = path.to_path
            # @see https://pandoc.org/MANUAL.html
            capture3! "pandoc", "--from", input_format, "--to", "plain", "--output", file, file
          end
        end
      end
    end

    def config_target
      config_linter[:target] || DEFAULT_TARGET
    end

    def config_ext
      config_linter[:ext] || DEFAULT_EXT
      ["md"]
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
        config_target,
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
