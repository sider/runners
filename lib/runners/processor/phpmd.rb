module Runners
  class Processor::Phpmd < Processor
    include PHP

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, base(
        target: target,
        rule: one_or_more_strings?,
        minimumpriority: numeric?,
        suffixes: one_or_more_strings?,
        exclude: one_or_more_strings?,
        strict: boolean?,
        custom_rule_path: one_or_more_strings?,
      )
    end

    register_config_schema SCHEMA.config

    DEFAULT_TARGET = ".".freeze
    DEFAULT_CONFIG_FILE = (Pathname(Dir.home) / "sider_recommended_phpmd.xml").to_path.freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        target: [src/, test/]
        rule: [cleancode, codesize]
        minimumpriority: 3
        suffixes: [php, phtml]
        exclude: [vendor/, "test/*.php"]
        strict: true
        custom_rule_path:
          - Custom_PHPMD_Rule.php
          - "custom/phpmd/rules/**/*.php"
      YAML
    end

    def analyze(changes)
      delete_unchanged_files(changes, only: target_files, except: Array(config_linter[:custom_rule_path]))
      run_analyzer(changes)
    end

    private

    def target_files
      _, value = suffixes
      value&.split(",")&.map { |suffix| "*.#{suffix}" } || ["*.php"]
    end

    def rule
      comma_separated_list(config_linter[:rule]) || DEFAULT_CONFIG_FILE
    end

    def target_dirs
      comma_separated_list(config_linter[:target]) || DEFAULT_TARGET
    end

    def minimumpriority
      priority = config_linter[:minimumpriority]
      priority ? ["--minimumpriority", priority.to_s] : []
    end

    def suffixes
      suffixes = comma_separated_list(config_linter[:suffixes])
      suffixes ? ["--suffixes", suffixes] : []
    end

    def exclude
      exclude = comma_separated_list(config_linter[:exclude])
      exclude ? ["--exclude", exclude] : []
    end

    def strict
      strict = config_linter[:strict]
      strict ? ["--strict"] : []
    end

    def run_analyzer(changes)
      # @see https://phpmd.org/documentation/index.html
      _stdout, stderr, status = capture3(
        analyzer_bin,
        target_dirs,
        "json",
        rule,
        "--ignore-violations-on-exit",
        "--ignore-errors-on-exit",
        "--report-file", report_file,
        *minimumpriority,
        *suffixes,
        *exclude,
        *strict,
      )

      unless status.success?
        if stderr.include? "Cannot find specified rule-set"
          return Results::Failure.new(guid: guid, analyzer: analyzer, message: "Invalid rule: #{rule.inspect}")
        elsif !stderr.empty?
          raise stderr
        else
          raise status.inspect
        end
      end

      json = read_report_json

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        # Note: See below to view the XML schema:
        #
        # @see https://github.com/phpmd/phpmd/blob/2.10.1/src/main/php/PHPMD/Renderer/JSONRenderer.php

        json.fetch(:files, []).each do |file|
          path = relative_path(file.fetch(:file))

          file.fetch(:violations).each do |violation|
            result.add_issue Issue.new(
              path: path,
              location: Location.new(start_line: violation.fetch(:beginLine), end_line: violation.fetch(:endLine)),
              id: violation.fetch(:rule),
              message: violation.fetch(:description),
              links: violation.fetch(:externalInfoUrl).then do |link|
                (link.nil? || link.empty?) ? [] : [link]
              end,
            )
          end
        end

        json.fetch(:errors, []).each do |error|
          filename = error.fetch(:fileName)
          message = error.fetch(:message)

          if filename.empty?
            add_warning message
            next
          end

          path = relative_path(filename)
          message.gsub!(filename, path.to_path) # NOTE: Convert an absolute path to a relative one.

          result.add_issue Issue.new(
            path: path,
            location: nil,
            id: "UnknownError", # NOTE: This ID is unique to Sider (probably not used elsewhere).
            message: message,
          )
        end
      end
    end
  end
end
