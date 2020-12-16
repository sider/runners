module Runners
  class Processor::Jshint < Processor
    include Nodejs

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                        dir: string?,
                        config: string?,
                        # DO NOT ADD ANY OPTIONS in `options` option.
                        options: optional(object(
                                            config: string?
                                          ))
                      })
      }
    end

    register_config_schema(name: :jshint, schema: Schema.runner_config)

    def setup
      add_warning_if_deprecated_options
      yield
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
        rescue REXML::ParseException => exn
          message = if exn.cause.instance_of? RuntimeError
                      exn.cause.message
                    else
                      exn.message
                    end
          message = "The output XML is invalid: #{message}"
          Results::Failure.new(guid: guid, message: message, analyzer: analyzer)
        end
      else
        Results::Failure.new(guid: guid, analyzer: analyzer)
      end
    end

    private

    def prepare_config
      return if jshintrc_exist?

      config = (Pathname(Dir.home) / 'sider_jshintrc').realpath
      ignore = (Pathname(Dir.home) / 'sider_jshintignore').realpath
      FileUtils.copy_file(config, current_dir / '.jshintrc')
      FileUtils.copy_file(ignore, current_dir / '.jshintignore')
    end

    def jshintrc_exist?
      return true if config_path
      return true if (current_dir + '.jshintrc').exist? || (current_dir + '.jshintignore').exist?

      begin
        return true if package_json_path.exist? && package_json[:jshintConfig]
      rescue JSON::ParserError => exn
        add_warning "`package.json` is broken: #{exn.message}", file: "package.json"
      end

      false
    end

    def config_path
      config_linter[:config] || config_linter.dig(:options, :config)
    end

    def parse_result(output)
      issues = []

      read_xml(output).each_element("file") do |file|
        file_name = file[:name]
        file_path = file_name ? relative_path(file_name) : nil

        file.each_element do |error|
          issues << Issue.new(
            path: file_path,
            location: Location.new(start_line: error[:line], start_column: error[:column]),
            id: error[:source],
            message: error[:message]&.strip,
          )
        end
      end

      issues
    end
  end
end
