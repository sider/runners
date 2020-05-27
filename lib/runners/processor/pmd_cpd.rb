module Runners
  class Processor::PmdCpd < Processor
    include Java

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                    'minimum-tokens': numeric?,
                    files: enum?(string, array(string)),
                    language: string?,
                    encoding: string?,
                    'skip-duplicate-files': boolean?,
                    'non-recursive': boolean?,
                    'skip-lexical-errors': boolean?,
                    'ignore-annotations': boolean?,
                    'ignore-identifiers': boolean?,
                    'ignore-literals': boolean?,
                    'ignore-usings': boolean?,
                    'no-skip-blocks': boolean?,
                    'skip-blocks-pattern': string?,
                  })
      }

      let :issue, object(
        lines: integer,
        tokens: integer,
        files: array(object(
          id: string,
          path: string,
          start_line: integer,
          start_column: integer,
          end_line: integer,
          end_column: integer
        )),
        codefragment: string
      )
    end

    DEFAULT_MINIMUM_TOKENS = 100
    DEFAULT_FILES = ".".freeze

    register_config_schema(name: :pmd_cpd, schema: Schema.runner_config)

    def analyzer_version
      @analyzer_version ||= capture3!("show_pmd_version").yield_self { |stdout,| stdout.strip }
    end

    def analyze(changes)
      run_analyzer
    end

    def run_analyzer
      stdout, stderr, status = capture3(analyzer_bin, *cli_options)
      if status.success? || status.exitstatus == 4
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          construct_result(result, stdout, stderr)
        end
      else
        Results::Failure.new(guid: guid, analyzer: analyzer, message: "Unexpected error occurred. Please see the analysis log.")
      end
    end

    def construct_result(result, stdout, stderr)
      stdout.sub!(/encoding=".*?"/,'') # Remove the encoding attribute to read this XML as UTF-8. The PMD CPD writes an XML report as UTF-8 with the inconsistent encoding attribute value when the --encoding option is specified.
      REXML::Document.new(stdout).each_element('pmd-cpd/duplication') do |elem_dupli|
        files = elem_dupli.get_elements('file').map{ |f| to_fileinfo(f) }
        issueobj = create_issue_object(elem_dupli, files)

        files.each do |file|
          result.add_issue Issue.new(
            id: file[:id],
            path: file[:path],
            location: file[:location],
            message: "Code duplications found (#{files.length} occurrences).",
            object: issueobj,
            schema: Schema.issue,
          )
        end
      end
    end

    def to_fileinfo(elem_file)
      path = relative_path(elem_file[:path])
      location = Location.new(
        start_line: elem_file[:line],
        start_column: elem_file[:column],
        end_line: elem_file[:endline],
        end_column: elem_file[:endcolumn],
      )
      id = Digest::SHA1.hexdigest(path.to_s + location.to_s) # In case multiple duplicates are found in a file, generate a hash from the file path and the location.

      return {
        id: id,
        path: path,
        location: location
      }
    end

    def create_issue_object(elem_dupli, files)
      lines = elem_dupli[:lines].to_i
      tokens = elem_dupli[:tokens].to_i
      codefragment = elem_dupli.elements['codefragment'].cdatas[0].value
      fileobjs = files.map { |f| {
        id: f[:id],
        path: f[:path].to_s,
        start_line: f[:location].start_line,
        start_column: f[:location].start_column,
        end_line: f[:location].end_line,
        end_column: f[:location].end_column,
      }}

      return {
        lines: lines,
        tokens: tokens,
        files: fileobjs,
        codefragment: codefragment
      }
    end

    def option_files
      Array(config_linter[:files] || DEFAULT_FILES).map { |v| ["--files", v] }.flatten
    end

    def option_encoding
      config_linter[:encoding].then { |v| v ? ["--encoding", v] : [] }
    end

    def option_minimum_tokens
      (config_linter[:'minimum-tokens'] || DEFAULT_MINIMUM_TOKENS).then { |v| ["--minimum-tokens", v.to_s] }
    end

    def option_language
      config_linter[:language].then { |v| v ? ["--language", v] : [] }
    end

    def option_skip_duplicate_files
      config_linter[:'skip-duplicate-files'].then { |v| v ? ["--skip-duplicate-files"] : [] }
    end

    def option_non_recursive
      config_linter[:'non-recursive'].then { |v| v ? ["--non-recursive"] : [] }
    end

    def option_skip_lexical_errors
      config_linter[:'skip-lexical-errors'].then { |v| v ? ["--skip-lexical-errors"] : [] }
    end

    def option_ignore_annotations
      config_linter[:'ignore-annotations'].then { |v| v ? ["--ignore-annotations"] : [] }
    end

    def option_ignore_identifiers
      config_linter[:'ignore-identifiers'].then { |v| v ? ["--ignore-identifiers"] : [] }
    end

    def option_ignore_literals
      config_linter[:'ignore-literals'].then { |v| v ? ["--ignore-literals"] : [] }
    end

    def option_ignore_usings
      config_linter[:'ignore-usings'].then { |v| v ? ["--ignore-usings"] : [] }
    end

    def option_no_skip_blocks
      config_linter[:'no-skip-blocks'].then { |v| v ? ["--no-skip-blocks"] : [] }
    end

    def option_skip_blocks_pattern
      config_linter[:'skip-blocks-pattern'].then { |v| v ? ["--skip-blocks-pattern", v] : [] }
    end

    def cli_options
      [
        *option_encoding,
        *option_minimum_tokens,
        *option_language,
        *option_skip_duplicate_files,
        *option_non_recursive,
        *option_skip_lexical_errors,
        *option_ignore_annotations,
        *option_ignore_identifiers,
        *option_ignore_literals,
        *option_ignore_usings,
        *option_no_skip_blocks,
        *option_skip_blocks_pattern,
        "--format", "xml",
        *option_files,
      ]
    end
  end
end
