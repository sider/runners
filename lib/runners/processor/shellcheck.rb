module Runners
  class Processor::ShellCheck < Processor
    Schema = _ = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        target_element = enum(string, object(shebang: boolean))
        fields.merge!(
          # Original options
          target: enum?(target_element, array(target_element)),

          # Native options
          include: enum?(string, array(string)),
          exclude: enum?(string, array(string)),
          enable: enum?(string, array(string)),
          shell: string?,
          severity: string?,
          norc: boolean?,
        )
      }

      let :issue, object(
        code: integer,
        severity: string,
        fix: object?(replacements: array(object(
          line: integer,
          column: integer,
          endLine: integer,
          endColumn: integer,
          precedence: integer,
          insertionPoint: string,
          replacement: string,
        ))),
      )
    end

    register_config_schema(name: :shellcheck, schema: Schema.runner_config)

    DEFAULT_TARGET = [
      "**/*.{bash,bats,dash,ksh,sh}",
      { shebang: true },
    ].freeze

    # NOTE: Follow file(1) format.
    #
    # @see https://linux.die.net/man/1/file
    SHELL_SCRIPT_SHEBANG_PATTERN = Regexp.union(
      "POSIX shell script",
      "Bourne-Again shell script",
      "Korn shell script",
      "/dash script",
      "/env bats script",
    ).freeze

    def self.ci_config_section_name
      "shellcheck"
    end

    def analyzer_name
      "ShellCheck"
    end

    def analyze(_changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        @config = config
        run_analyzer
      end
    end

    private

    def config
      @config or raise "Must be initialized!"
    end

    def find_files_with_shebang
      trace_writer.message "Finding files with shell script shebang..."

      # NOTE: No "Shell Injection Attack" because of not using user input.
      # NOTE: Using pipe aims to quickly detect files in a huge project tree.
      stdout, = capture3!(
        "find . -type f -printf '%P\\n' | " +
          "xargs --no-run-if-empty -I {} file {} | " +
          "awk -F: '#{SHELL_SCRIPT_SHEBANG_PATTERN.inspect} { print $1 }'",
        trace_stdout: false, # Avoid too many lines output
      )

      stdout.lines(chomp: true).tap do |files|
        trace_writer.message "#{files.size} file(s) found."
      end
    end

    def analyzed_files
      # Via glob
      targets = Array(config[:target] || DEFAULT_TARGET)
      globs = targets.select { |glob| glob.is_a? String }
      files_via_glob = Dir.glob(globs, File::FNM_EXTGLOB, base: current_dir)

      # Via shebang
      shebang = (targets - globs).find { |target| target.fetch(:shebang, false) }
      files_via_shebang = shebang ? find_files_with_shebang : []

      # Aggregate (sorting for stable tests)
      files_via_glob.union(files_via_shebang).sort
    end

    def option_values(name, sep)
      Array(config[name]).join(sep).split(sep).map(&:strip).join(sep)
    end

    def analyzer_options
      [].tap do |opts|
        opts << "--format=json1"
        option_values(:include, ",").tap { |val| opts << "--include=#{val}" unless val.empty? }
        option_values(:exclude, ",").tap { |val| opts << "--exclude=#{val}" unless val.empty? }
        option_values(:enable, ",").tap { |val| opts << "--enable=#{val}" unless val.empty? }
        config[:shell].tap { |val| opts << "--shell=#{val}" if val }
        config[:severity].tap { |val| opts << "--severity=#{val}" if val }
        opts << "--norc" if config[:norc]
      end
    end

    def run_analyzer
      files = analyzed_files

      trace_writer.message "Analyzing #{files.size} file(s)..."

      stdout, stderr, status = capture3(analyzer_bin, *analyzer_options, *files)

      # @see https://github.com/koalaman/shellcheck/blob/de9ab4e6ef5262eeba6871a03ef3938a93b44395/shellcheck.1.md#return-values
      if [0, 1].include? status.exitstatus
        Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
          parse_result(stdout) do |issue|
            result.add_issue(issue)
          end
        end
      elsif stderr.start_with? "No files specified."
        Results::Success.new(guid: guid, analyzer: analyzer)
      else
        message = "An unexpected error occurred. Check the log output."
        Results::Failure.new(guid: guid, message: message, analyzer: analyzer)
      end
    end

    def parse_result(output)
      json = JSON.parse(output, symbolize_names: true)
      json.fetch(:comments).each do |comment|
        id = "SC#{comment[:code]}"
        yield Issue.new(
          id: id,
          path: relative_path(comment[:file]),
          location: Location.new(
            start_line: comment[:line],
            start_column: comment[:column],
            end_line: comment[:endLine],
            end_column: comment[:endColumn],
          ),
          message: comment[:message],
          links: ["https://github.com/koalaman/shellcheck/wiki/#{id}"],
          object: {
            code: comment[:code],
            severity: comment[:level],
            fix: comment[:fix],
          },
          schema: Schema.issue,
        )
      end
    end
  end
end
