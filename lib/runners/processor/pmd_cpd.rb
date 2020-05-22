module Runners
  class Processor::PmdCpd < Processor
    include Java

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                    minimum_tokens: numeric?,
                    files: string?,
                    filelist: string?,
                    language: string?,
                    encoding: string?,
                    skip_duplicate_files: boolean?,
                    non_recursive: boolean?,
                    skip_lexical_errors: boolean?,
                    ignore_annotations: boolean?,
                    ignore_identifiers: boolean?,
                    ignore_literals: boolean?,
                    ignore_usings: boolean?,
                    no_skip_blocks: boolean?,
                    skip_blocks_pattern: string?,
                  })
      }

      let :issue, object(
        codefragment: string
      )
    end

    DEFAULT_MINIMUM_TOKENS = "100".freeze
    DEFAULT_FILES = ".".freeze

    register_config_schema(name: :pmd_cpd, schema: Schema.runner_config)

    def analyzer_version
      @analyzer_version ||= capture3!("show_pmd_version").yield_self { |stdout,| stdout.strip }
    end

    def analyzer_bin
      "cpd"
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
      REXML::Document.new(stdout).each_element('pmd-cpd/duplication') do |elem_dupli|
        codefragment = elem_dupli.elements['codefragment'].cdatas[0].value
        files = elem_dupli.get_elements('file').map{ |f| to_fileinfo(f) }

        files.each do |file|
          result.add_issue Issue.new(
            id: file[:id],
            path: file[:path],
            location: file[:location],
            message: "Code duplications found (#{files.length} occurrences).",
            object: {
              codefragment: codefragment
            },
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
      id = Digest::SHA1.hexdigest(path.to_s)
      return {
        id: id,
        path: path,
        location: location
      }
    end

    def option_files
      config_linter[:files].then { |v| v ? ["--files", v] : ["--files", DEFAULT_FILES] }
    end

    def option_filelist
      config_linter[:filelist].then { |v| v ? ["--filelist", v] : [] }
    end

    def option_encoding
      config_linter[:encoding].then { |v| v ? ["--encoding", v] : [] }
    end

    def option_minimum_tokens
      config_linter[:minimum_tokens].then do |v|
        v ? ["--minimum-tokens", v.to_s] : ["--minimum-tokens", DEFAULT_MINIMUM_TOKENS]
      end
    end

    def option_language
      config_linter[:language].then { |v| v ? ["--language", v] : [] }
    end

    def option_skip_duplicate_files
      config_linter[:skip_duplicate_files].then { |v| v ? ["--skip-duplicate-files"] : [] }
    end

    def option_non_recursive
      config_linter[:non_recursive].then { |v| v ? ["--non-recursive"] : [] }
    end

    def option_skip_lexical_errors
      config_linter[:skip_lexical_errors].then { |v| v ? ["--skip-lexical-errors"] : [] }
    end

    def option_ignore_annotations
      config_linter[:ignore_annotations].then { |v| v ? ["--ignore-annotations"] : [] }
    end

    def option_ignore_identifiers
      config_linter[:ignore_identifiers].then { |v| v ? ["--ignore-identifiers"] : [] }
    end

    def option_ignore_literals
      config_linter[:ignore_literals].then { |v| v ? ["--ignore-literals"] : [] }
    end

    def option_ignore_usings
      config_linter[:ignore_usings].then { |v| v ? ["--ignore-usings"] : [] }
    end

    def option_no_skip_blocks
      config_linter[:no_skip_blocks].then { |v| v ? ["--no-skip-blocks"] : [] }
    end

    def option_skip_blocks_pattern
      config_linter[:skip_blocks_pattern].then { |v| v ? ["--skip-blocks-pattern", v] : [] }
    end

    def cli_options
      [
        *option_encoding,
        *option_minimum_tokens,
        *option_language,
        *option_skip_duplicate_files,
        *option_non_recursive,
        *option_skip_lexical_errors,
        *option_filelist,
        *option_ignore_usings,
        *option_no_skip_blocks,
        *option_skip_blocks_pattern,
        "--format", "xml",
        *option_files,
      ]
    end
  end
end
