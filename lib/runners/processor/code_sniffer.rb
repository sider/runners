module Runners
  class Processor::CodeSniffer < Processor
    include PHP

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :target, enum?(string, array(string))

      let :runner_config, Runners::Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
          version: enum?(string, numeric),
          target: target,
          dir: target, # alias for `target`
          standard: enum?(string, array(string)),
          extensions: enum?(string, array(string)),
          encoding: string?,
          ignore: enum?(string, array(string)),
          parallel: boolean?,
        })
      }

      let :issue, object(
        type: string,
        severity: integer,
        fixable: boolean,
      )
    end

    register_config_schema(name: :code_sniffer, schema: Schema.runner_config)

    DefaultOptions = _ = Struct.new(:standard, :extensions, :target, keyword_init: true)
    OPTIONS_CAKE_PHP = DefaultOptions.new(standard: "CakePHP", extensions: "php", target: "app/").freeze
    OPTIONS_SYMFONY = DefaultOptions.new(standard: "Symfony", extensions: "php", target: "src/").freeze
    OPTIONS_PSR2 = DefaultOptions.new(standard: "PSR2", extensions: "php", target: "./").freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        target: [app/, test/]
        standard: [CakePHP, custom-ruleset.xml]
        extensions: [php, inc]
        encoding: utf-8
        ignore:
          - app/vendor/
        parallel: true
      YAML
    end

    def analyzer_bin
      "phpcs"
    end

    def analyze(changes)
      capture3!(
        analyzer_bin,
        "--report=json",
        "--report-json=#{report_file}",
        "-q", # Enable quiet mode. See https://github.com/squizlabs/PHP_CodeSniffer/wiki/Advanced-Usage#quieting-output
        "--runtime-set", "ignore_errors_on_exit", "1", # See https://github.com/squizlabs/PHP_CodeSniffer/wiki/Configuration-Options#ignoring-errors-when-generating-the-exit-code
        "--runtime-set", "ignore_warnings_on_exit", "1", # See https://github.com/squizlabs/PHP_CodeSniffer/wiki/Configuration-Options#ignoring-warnings-when-generating-the-exit-code
        *additional_options,
        *Array(config_linter[:target] || config_linter[:dir] || default_options.target),
      )

      issues = []

      read_report_json.fetch(:files).each do |file, suggests|
        path = relative_path(file.to_s)

        suggests.fetch(:messages).each do |suggest|
          issues << Issue.new(
            path: path,
            location: Location.new(start_line: suggest[:line], start_column: suggest[:column]),
            id: suggest[:source],
            message: suggest[:message],
            object: {
              type: suggest[:type],
              severity: suggest[:severity],
              fixable: suggest[:fixable],
            },
            schema: Schema.issue,
          )
        end
      end

      issues.uniq! { |issue| [issue.path, issue.location, issue.id, issue.message] }

      Results::Success.new(guid: guid, analyzer: analyzer, issues: issues)
    end

    private

    def additional_options
      if config_linter.empty?
        [
          "--standard=#{default_options.standard}",
          "--extensions=#{default_options.extensions}",
        ]
      else
        [
          "--standard=#{comma_separated_list(config_linter[:standard] || default_options.standard)}",
          "--extensions=#{comma_separated_list(config_linter[:extensions] || default_options.extensions)}",
          *(config_linter[:encoding].then { |enc| enc ? ["--encoding=#{enc}"] : [] }),
          *(comma_separated_list(config_linter[:ignore]).then { |list| list ? ["--ignore=#{list}"] : [] }),
          *(config_linter[:parallel] ? ["--parallel=2"] : []),
        ]
      end
    end

    def default_options
      @default_options ||=
        case php_framework
        when :CakePHP
          OPTIONS_CAKE_PHP
        when :Symfony
          OPTIONS_SYMFONY
        else
          OPTIONS_PSR2
        end
    end

    def php_framework
      return :CakePHP if File.exist? 'lib/Cake/Core/CakePlugin.php'
      return :Symfony if File.exist? 'app/SymfonyRequirements.php'
      nil
    end
  end
end
