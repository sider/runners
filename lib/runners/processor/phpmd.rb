module Runners
  class Processor::Phpmd < Processor
    include PHP

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                        target: enum?(string, array(string)),
                        rule: enum?(string, array(string)),
                        minimumpriority: numeric?,
                        suffixes: enum?(string, array(string)),
                        exclude: enum?(string, array(string)),
                        strict: boolean?,
                        custom_rule_path: array?(string),
                        # DO NOT ADD ANY OPTIONS in `options` option.
                        options: optional(object(
                                            rule: string?,
                                            minimumpriority: numeric?,
                                            suffixes: string?,
                                            exclude: string?,
                                            strict: boolean?
                                          ))
                      })
      }
    end

    register_config_schema(name: :phpmd, schema: Schema.runner_config)

    DEFAULT_TARGET = ".".freeze
    DEFAULT_CONFIG_FILE = (Pathname(Dir.home) / "sider_config.xml").to_path.freeze

    def setup
      add_warning_if_deprecated_options
      yield
    end

    def analyze(changes)
      delete_unchanged_files(changes, only: target_files, except: config_linter[:custom_rule_path] || [])
      run_analyzer(changes)
    end

    private

    def target_files
      _, value = suffixes
      value&.split(",")&.map { |suffix| "*.#{suffix}" } || ["*.php"]
    end

    def rule
      rules = config_linter[:rule] || config_linter.dig(:options, :rule)
      comma_separated_list(rules) || DEFAULT_CONFIG_FILE
    end

    def target_dirs
      comma_separated_list(config_linter[:target]) || DEFAULT_TARGET
    end

    def minimumpriority
      priority = config_linter[:minimumpriority] || config_linter.dig(:options, :minimumpriority)
      priority ? ["--minimumpriority", priority.to_s] : []
    end

    def suffixes
      suffixes = comma_separated_list(config_linter[:suffixes] || config_linter.dig(:options, :suffixes))
      suffixes ? ["--suffixes", suffixes] : []
    end

    def exclude
      exclude = comma_separated_list(config_linter[:exclude] || config_linter.dig(:options, :exclude))
      exclude ? ["--exclude", exclude] : []
    end

    def strict
      strict = config_linter[:strict] || config_linter.dig(:options, :strict)
      strict ? ["--strict"] : []
    end

    def run_analyzer(changes)
      # PHPMD exits 1 when some violations are found.
      # The `--ignore-violation-on-exit` will exit with a zero code, even if any violations are found.
      # See https://phpmd.org/documentation/index.html
      _stdout, stderr, status = capture3(
        analyzer_bin,
        target_dirs,
        "xml",
        rule,
        "--ignore-violations-on-exit",
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

      begin
        xml_root = read_report_xml
      rescue REXML::ParseException => exn
        trace_writer.error exn.message
        return Results::Failure.new(guid: guid, analyzer: analyzer,
                                    message: "Invalid XML was output. See the log for details.")
      end

      change_paths = changes.changed_paths
      errors = []
      xml_root.each_element('error') do |error|
        errors << error[:msg] if change_paths.include?(relative_path(error[:filename]))
      end
      unless errors.empty?
        errors.each { |message| trace_writer.error message }
        return Results::Failure.new(guid: guid, message: errors.join("\n"), analyzer: analyzer)
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        xml_root.each_element('file') do |file|
          path = relative_path(file[:name])

          file.each_element('violation') do |violation|
            result.add_issue Issue.new(
              path: path,
              location: Location.new(start_line: violation[:beginline], end_line: violation[:endline]),
              id: violation[:rule],
              message: violation.text.strip,
              links: Array(violation[:externalInfoUrl]),
            )
          end
        end
      end
    end
  end
end
