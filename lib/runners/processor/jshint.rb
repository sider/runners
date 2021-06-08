module Runners
  class Processor::Jshint < Processor
    include Nodejs

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, base(
        target: target,
        dir: target, # alias for `target`
        config: string?,
      )

      let :issue, object(
        severity: string,
      )
    end

    register_config_schema SCHEMA.config

    DEFAULT_TARGET = ".".freeze
    DEFAULT_CONFIG_FILE = (Pathname(Dir.home) / 'sider_jshintrc').to_path.freeze
    DEFAULT_IGNORE_FILE = (Pathname(Dir.home) / 'sider_jshintignore').to_path.freeze
    CUSTOM_JSON_REPORTER = (Pathname(Dir.home) / 'custom-json-reporter.js').to_path.freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        target: src/
        config: config/.jshintrc.json
      YAML
    end

    def setup
      # @see https://jshint.com/docs/
      jshintrc = current_dir / '.jshintrc'
      if !jshintrc.exist? && !jshint_config_in_package_json?
        FileUtils.copy_file DEFAULT_CONFIG_FILE, jshintrc
      end

      jshintignore = current_dir / '.jshintignore'
      if !jshintignore.exist?
        FileUtils.copy_file DEFAULT_IGNORE_FILE, jshintignore
      end

      yield
    end

    def analyze(_changes)
      args = []
      args << "--reporter" << CUSTOM_JSON_REPORTER
      jshint_config_path&.tap { |path| args << "--config" << path }
      args += Array(config_linter[:target] || config_linter[:dir] || DEFAULT_TARGET)

      stdout, _stderr, status = capture3(analyzer_bin, *args)

      case status.exitstatus
      when 0, 2
        Results::Success.new(guid: guid, analyzer: analyzer, issues: parse_result(stdout))
      else
        Results::Failure.new(guid: guid, analyzer: analyzer)
      end
    end

    private

    def jshint_config_in_package_json?
      package_json_path.file? && package_json[:jshintConfig]
    rescue JSON::ParserError => exn
      add_warning "`#{PACKAGE_JSON}` is broken: #{exn.message}", file: PACKAGE_JSON
      false
    end

    def jshint_config_path
      config_linter[:config]
    end

    def parse_result(output)
      JSON.parse(output, symbolize_names: true).fetch(:issues).map do |issue|
        Issue.new(
          id: issue.fetch(:code),
          message: issue.fetch(:message),
          path: relative_path(issue.fetch(:file)),
          location: Location.new(start_line: issue.fetch(:line), start_column: issue.fetch(:column)),
          object: {
            severity: issue.fetch(:severity),
          },
          schema: SCHEMA.issue,
        )
      end
    end
  end
end
