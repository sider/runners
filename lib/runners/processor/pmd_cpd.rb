module Runners
  class Processor::PmdCpd < Processor
    include Java

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :available_languages, enum(
        literal("apex"),
        literal("cpp"),
        literal("cs"),
        literal("dart"),
        literal("ecmascript"),
        literal("fortran"),
        literal("go"),
        literal("groovy"),
        literal("java"),
        literal("jsp"),
        literal("kotlin"),
        literal("lua"),
        literal("matlab"),
        literal("modelica"),
        literal("objectivec"),
        literal("perl"),
        literal("php"),
        literal("plsql"),
        literal("python"),
        literal("ruby"),
        literal("scala"),
        literal("swift"),
        literal("vf"),
        literal("xml")
      )

      let :config, base(
        'minimum-tokens': numeric?,
        files: target,
        language: enum?(available_languages, array(available_languages)),
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
      )

      let :issue, object(
        lines: integer,
        tokens: integer,
        files: array(object(
          id: string,
          path: string,
          start_line: integer,
          start_column: integer?,
          end_line: integer,
          end_column: integer?
        )),
        codefragment: string
      )
    end

    DEFAULT_MINIMUM_TOKENS = 100
    DEFAULT_FILES = ".".freeze
    DEFAULT_LANGUAGE = ["cpp", "cs", "ecmascript", "go", "java", "kotlin", "php", "python", "ruby", "swift"].freeze

    register_config_schema(name: :pmd_cpd, schema: SCHEMA.config)

    def self.config_example
      <<~'YAML'
        root_dir: project/
        minimum-tokens: 70
        files: src/
        language: [ecmascript, ruby]
        encoding: ISO-8859-1
        skip-duplicate-files: true
        non-recursive: true
        skip-lexical-errors: true
        ignore-annotations: true
        ignore-identifiers: true
        ignore-literals: true
        ignore-usings: true
        no-skip-blocks: true
        skip-blocks-pattern: "#ifdef TEST|#endif"
      YAML
    end

    attr_accessor :force_option_skip_lexical_errors

    def analyzer_version
      @analyzer_version ||= capture3!("show_pmd_version").yield_self { |stdout,| stdout.strip }
    end

    def analyze(_changes)
      issues = []

      languages.each do |language|
        stdout, stderr = capture3!(analyzer_bin, *cli_options(language))
        raise_warnings(stderr)
        construct_result(stdout) { |issue| issues << issue }
      end

      Results::Success.new(guid: guid, analyzer: analyzer, issues: issues)
    end

    private

    def raise_warnings(stderr)
      stderr.each_line do |line|
        if line.start_with?("Skipping")
          add_warning line.gsub(working_dir.to_s + '/', '')
        end
      end
    end

    def construct_result(stdout)
      # HACK: Replace the encoding attribute to read this XML as UTF-8.
      #       The PMD CPD writes an XML report as UTF-8 with the inconsistent encoding attribute value when the --encoding option is specified.
      stdout.sub!(/<\?xml version="1\.0" encoding=".+"\?>/, '<?xml version="1.0" encoding="UTF-8"?>')

      read_xml(stdout).each_element('duplication') do |elem_dupli|
        files = elem_dupli.get_elements('file').map{ |f| to_fileinfo(f) }

        files.each do |file|
          yield Issue.new(
            id: file[:id],
            path: file[:path],
            location: file[:location],
            message: "Code duplications found (#{files.length} occurrences).",
            object: create_issue_object(elem_dupli, files),
            schema: SCHEMA.issue,
          )
        end
      end
    end

    def to_fileinfo(elem_file)
      filename = elem_file[:path] or raise "required path: #{elem_file.inspect}"
      path = relative_path(filename)

      location = Location.new(
        start_line: elem_file[:line],
        start_column: elem_file[:column],
        end_line: elem_file[:endline],
        end_column: elem_file[:endcolumn],
      )
      id = Digest::SHA1.hexdigest("#{path}#{location}") # In case multiple duplicates are found in a file, generate a hash from the file path and the location.

      { id: id, path: path, location: location }
    end

    def create_issue_object(elem_dupli, files)
      lines_text = elem_dupli[:lines] or raise "required lines: #{elem_dupli.inspect}"
      lines = Integer(lines_text)

      tokens_text = elem_dupli[:tokens] or raise "required tokens: #{elem_dupli.inspect}"
      tokens = Integer(tokens_text)

      codefragment = elem_dupli.elements['codefragment']&.cdatas&.first&.value
      codefragment or raise "required codefragment: #{elem_dupli.inspect}"

      fileobjs = files.map do |f|
        {
          id: f[:id],
          path: f[:path].to_path,
          start_line: f[:location].start_line,
          start_column: f[:location].start_column,
          end_line: f[:location].end_line,
          end_column: f[:location].end_column,
        }
      end

      {
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

    def languages
      Array(config_linter[:language] || DEFAULT_LANGUAGE)
    end

    def option_language(v)
      ["--language", v]
    end

    def option_skip_duplicate_files
      config_linter[:'skip-duplicate-files'].then { |v| v ? ["--skip-duplicate-files"] : [] }
    end

    def option_non_recursive
      config_linter[:'non-recursive'].then { |v| v ? ["--non-recursive"] : [] }
    end

    def option_skip_lexical_errors
      (force_option_skip_lexical_errors || config_linter[:'skip-lexical-errors']).then { |v| v ? ["--skip-lexical-errors"] : [] }
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

    def cli_options(language)
      [
        *option_encoding,
        *option_minimum_tokens,
        *option_language(language),
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
        "--failOnViolation", "false",
        *option_files,
      ]
    end
  end
end
