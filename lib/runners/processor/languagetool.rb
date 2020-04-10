module Runners
  class Processor::LanguageTool < Processor
    include Java

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
          target: string?,
          language: string?,
          encoding: string?,
        })
      }
      let :issue, object(severity: string?)
    end

    register_config_schema(name: :languagetool, schema: Schema.runner_config)

    DEFAULT_FILE_PATTERN = "*.{md,markdown,rst,txt}".freeze
    DEFAULT_TARGET = ".".freeze
    DEFAULT_LANGUAGE = "en-US".freeze # Specify a variant for spell checking
    DEFAULT_ENCODING = "UTF-8".freeze # Java-recognized encoding

    def analyze(changes)
      delete_unchanged_files(changes, except: [DEFAULT_FILE_PATTERN])

      run_analyzer
    end

    private

    def config_language
      lang = config_linter[:language] || DEFAULT_LANGUAGE
      ["--language", lang]
    end

    def config_encoding
      enc = config_linter[:encoding] || DEFAULT_ENCODING
      ["--encoding", enc]
    end

    def config_target
      Array(config_linter[:target] || DEFAULT_TARGET)
    end

    def cli_args
      [
        "--json",
        "--recursive",
        *config_language,
        *config_encoding,
        *config_target,
      ]
    end

    def run_analyzer
      stdout_and_stderr, = capture3!(analyzer_bin, *cli_args, merge_output: true)

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        parse_output(stdout_and_stderr) do |file, data|
          data.fetch(:matches).each do |match|
            result.add_issue Issue.new(
              path: file,
              location: nil,
              id: match.dig(:rule, :id),
              message: "#{match[:message]} -> #{match[:sentence]}",
            )
          end
        end
      end
    end

    def parse_output(output, &block)
      file = nil
      output.each_line(chomp: true) do |line|
        if file
          data = JSON.parse(line, symbolize_names: true)
          block.call(file, data)
          file = nil
        else
          line.match(/Working on (.+)\.\.\./) do |m|
            file = relative_path(m.captures.first)
          end
        end
      end
    end
  end
end
