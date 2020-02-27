module Runners
  class Processor::Jshint < Processor
    include Nodejs

    Schema = StrongJSON.new do
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

    def self.ci_config_section_name
      'jshint'
    end

    def analyzer_name
      'JSHint'
    end

    def setup
      add_warning_if_deprecated_options([:options], doc: "https://help.sider.review/tools/javascript/jshint")
      yield
    end

    def analyze(changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        prepare_config(config)
        run_analyzer(config)
      end
    end

    private

    def prepare_config(config)
      return if jshintrc_exist?(config)
      config = (Pathname(Dir.home) / 'sider_jshintrc').realpath
      ignore = (Pathname(Dir.home) / 'sider_jshintignore').realpath
      FileUtils.cp(config, current_dir / '.jshintrc')
      FileUtils.cp(ignore, current_dir / '.jshintignore')
    end

    def jshintrc_exist?(config)
      return true if config_path(config)
      return true if (current_dir + '.jshintrc').exist? || (current_dir + '.jshintignore').exist?

      begin
        return true if package_json_path.exist? && package_json[:jshintConfig]
      rescue JSON::ParserError => exn
        add_warning "`package.json` is broken: #{exn.message}", file: "package.json"
      end

      false
    end

    def config_path(config)
      config[:config] || config.dig(:options, :config)
    end

    def parse_result(output)
      REXML::Document.new(output).root.each_element("file") do |file|
        file.each_element do |error|
          message = error[:message].strip
          yield Issue.new(
            path: relative_path(file[:name]),
            location: Location.new(start_line: error[:line]),
            id: error[:source] || Digest::SHA1.hexdigest(message),
            message: message.strip,
          )
        end
      end
    end

    def run_analyzer(config)
      args = []
      args << "--reporter=checkstyle"
      args << "--config=#{config_path(config)}" if config_path(config)
      args << (config[:dir] || "./")
      stdout, stderr, status = capture3(analyzer_bin, *args)
      # If command is succeeded, status.exitstatus is 0 or 2(issues are found).
      return Results::Failure.new(guid: guid, message: stderr, analyzer: analyzer) if status.exitstatus == 1
      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        break result if status.exitstatus == 0
        parse_result(stdout) { |issue| result.add_issue(issue) }
      end
    rescue REXML::ParseException => exn
      message = if exn.cause.instance_of? RuntimeError
                  exn.cause.message
                else
                  exn.message
                end
      message = "The output XML is invalid: #{message}"
      Results::Failure.new(guid: guid, message: message, analyzer: analyzer)
    end
  end
end
