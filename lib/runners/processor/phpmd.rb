module Runners
  class Processor::Phpmd < Processor
    include PHP

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
                        target: enum?(string, array(string)),
                        rule: string?,
                        minimumpriority: numeric?,
                        suffixes: string?,
                        exclude: string?,
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

    def self.ci_config_section_name
      "phpmd"
    end

    def analyzer_name
      "phpmd"
    end

    def setup
      add_warning_if_deprecated_options([:options], doc: "https://help.sider.review/tools/php/phpmd")
      yield
    end

    def analyze(changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        check_runner_config(config) do |targets, rule, options|
          delete_unchanged_files(changes, only: target_files(config), except: config[:custom_rule_path] || [])
          run_analyzer(changes, targets, rule, options)
        end
      end
    end

    private

    def target_files(config)
      _, suffixes = suffixes(config)
      suffixes&.split(",")&.map { |suffix| "*.#{suffix}" } || ["*.php"]
    end

    def check_runner_config(config)
      # Options which have default values.
      targets = target_dirs(config)
      rule = rule(config)

      # Additional options.
      minimumpriority = minimumpriority(config)
      suffixes = suffixes(config)
      exclude = exclude(config)
      strict = strict(config)

      options = [minimumpriority, suffixes, exclude, strict].flatten.compact
      yield targets, rule, options
    end

    def rule(config)
      rules = config[:rule] || config.dig(:options, :rule)
      if rules
        rules
      else
        # NOTE: It assumes that default config xml is located in $HOME
        (Pathname(Dir.home) / 'sider_config.xml').realpath.to_s
      end
    end

    def target_dirs(config)
      Array(config[:target] || './').flat_map { |target| target.split(',') }.join(',')
    end

    def minimumpriority(config)
      min_priority = config[:minimumpriority] || config.dig(:options, :minimumpriority)
      ["--minimumpriority", "#{min_priority}"] if min_priority
    end

    def suffixes(config)
      suffixes = config[:suffixes] || config.dig(:options, :suffixes)
      ["--suffixes", "#{suffixes}"] if suffixes
    end

    def exclude(config)
      exclude = config[:exclude] || config.dig(:options, :exclude)
      ["--exclude", "#{exclude}"] if exclude
    end

    def strict(config)
      strict = config[:strict] || config.dig(:options, :strict)
      ["--strict"] if strict
    end

    def run_analyzer(changes, targets, rule, options)
      report_file = working_dir / "phpmd-report-#{Time.now.to_i}.xml"

      # PHPMD exits 1 when some violations are found.
      # The `--ignore-violation-on-exit` will exit with a zero code, even if any violations are found.
      # See https://phpmd.org/documentation/index.html
      command_line = [
        analyzer_bin, targets, "xml", rule, "--ignore-violations-on-exit",
        "--report-file", report_file.to_s, *options,
      ]
      capture3!(*command_line)

      output_xml =
        if report_file.exist?
          report_file.read
        else
          raise "Failed to output a report file via the command: #{command_line.join(' ')}"
        end

      trace_writer.message output_xml

      begin
        xml_doc = REXML::Document.new(output_xml)
      rescue REXML::ParseException => exn
        trace_writer.error exn.message
        return Results::Failure.new(guid: guid, analyzer: analyzer,
                                    message: "Invalid XML was output. See the log for details.")
      end

      change_paths = changes.changed_paths
      errors = []
      xml_doc.root.each_element('error') do |error|
        errors << error[:msg] if change_paths.include?(relative_path(error[:filename]))
      end
      unless errors.empty?
        errors.each { |message| trace_writer.error message }
        return Results::Failure.new(guid: guid, message: errors.join("\n"), analyzer: analyzer)
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        xml_doc.root.each_element('file') do |file|
          file.each_element('violation') do |violation|
            loc = Location.new(
              start_line: violation[:beginline],
              start_column: nil,
              end_line: violation[:endline],
              end_column: nil
            )

            result.add_issue Issue.new(
              path: relative_path(file[:name]),
              location: loc,
              id: violation[:rule],
              message: violation.text.strip,
              links: [violation[:externalInfoUrl]].compact,
            )
          end
        end
      end
    end
  end
end
