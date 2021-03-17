module Runners
  class Processor::Jshint < Processor
    include Nodejs

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
          dir: string?,
          config: string?,
        })
      }
    end

    register_config_schema(name: :jshint, schema: Schema.runner_config)

    DEFAULT_CONFIG_FILE = (Pathname(Dir.home) / 'sider_jshintrc').to_path.freeze
    DEFAULT_IGNORE_FILE = (Pathname(Dir.home) / 'sider_jshintignore').to_path.freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        dir: src/
        config: config/.jshintrc.json
      YAML
    end

    def analyze(changes)
      prepare_config

      args = []
      args << "--reporter=checkstyle"
      args << "--config=#{config_path}" if config_path
      args << (config_linter[:dir] || "./")
      stdout, _stderr, status = capture3(analyzer_bin, *args)

      case status.exitstatus
      when 0
        Results::Success.new(guid: guid, analyzer: analyzer)
      when 2
        begin
          Results::Success.new(guid: guid, analyzer: analyzer, issues: parse_result(stdout))
        rescue InvalidXML => exn
          Results::Failure.new(guid: guid, analyzer: analyzer, message: exn.message)
        end
      else
        Results::Failure.new(guid: guid, analyzer: analyzer)
      end
    end

    private

    def prepare_config
      return if jshintrc_exist?

      FileUtils.copy_file(DEFAULT_CONFIG_FILE, current_dir / '.jshintrc')
      FileUtils.copy_file(DEFAULT_IGNORE_FILE, current_dir / '.jshintignore')
    end

    def jshintrc_exist?
      return true if config_path
      return true if (current_dir / '.jshintrc').exist? || (current_dir / '.jshintignore').exist?

      begin
        return true if package_json_path.exist? && package_json[:jshintConfig]
      rescue JSON::ParserError => exn
        add_warning "`package.json` is broken: #{exn.message}", file: "package.json"
      end

      false
    end

    def config_path
      config_linter[:config]
    end

    def parse_result(output)
      issues = []

      read_xml(output).each_element("file") do |file|
        filename = file[:name] or raise "required file: #{file.inspect}"

        file.each_element do |error|
          message = error[:message] or raise "required message: #{error.inspect}"

          issues << Issue.new(
            path: relative_path(filename),
            location: Location.new(start_line: error[:line], start_column: error[:column]),
            id: error[:source],
            message: message.strip,
          )
        end
      end

      issues
    end
  end
end
