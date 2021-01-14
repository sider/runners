module Runners
  class Processor::ShellCheck < Processor
    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

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

    def analyze(_changes)
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
        Results::Failure.new(guid: guid, analyzer: analyzer)
      end
    end

    private

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
        trace_writer.message "#{files.size} file(s) found via shebang."
      end
    end

    def analyzed_files
      # @type var targets: Array[target]
      targets = Array(config_linter[:target] || DEFAULT_TARGET)

      # Via glob
      globs = _ = targets.select { |glob| glob.is_a? String } # TODO: Ignored Steep error
      files_via_glob = Dir.glob(globs, File::FNM_EXTGLOB, base: current_dir.to_path).filter { |path| File.file?(path) }

      # Via shebang
      shebang = (targets - globs).find do |target|
        target.is_a?(Hash) && target.fetch(:shebang, false)
      end
      files_via_shebang = shebang ? find_files_with_shebang : []

      # Aggregate (sorting for stable tests)
      files_via_glob.union(files_via_shebang).sort
    end

    def option_values(name, sep)
      Array(config_linter[name]).join(sep).split(sep).map(&:strip).join(sep)
    end

    def analyzer_options
      [].tap do |opts|
        opts << "--format=json1"
        option_values(:include, ",").tap { |val| opts << "--include=#{val}" unless val.empty? }
        option_values(:exclude, ",").tap { |val| opts << "--exclude=#{val}" unless val.empty? }
        option_values(:enable, ",").tap { |val| opts << "--enable=#{val}" unless val.empty? }
        config_linter[:shell].tap { |val| opts << "--shell=#{val}" if val }
        config_linter[:severity].tap { |val| opts << "--severity=#{val}" if val }
        opts << "--norc" if config_linter[:norc]
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
