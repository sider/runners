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

    def setup
      add_warning_if_deprecated_options([:options])
      yield
    end

    def analyze(changes)
      delete_unchanged_files(changes, only: target_files, except: config_linter[:custom_rule_path] || [])
      options = [minimumpriority, suffixes, exclude, strict].flatten.compact
      run_analyzer(changes, target_dirs, rule, options)
    end

    private

    def target_files
      _, value = suffixes
      value&.split(",")&.map { |suffix| "*.#{suffix}" } || ["*.php"]
    end

    def rule
      rules = config_linter[:rule] || config_linter.dig(:options, :rule)
      if rules
        rules
      else
        # NOTE: It assumes that default config xml is located in $HOME
        (Pathname(Dir.home) / 'sider_config.xml').realpath.to_s
      end
    end

    def target_dirs
      Array(config_linter[:target] || './').flat_map { |target| target.split(',') }.join(',')
    end

    def minimumpriority
      min_priority = config_linter[:minimumpriority] || config_linter.dig(:options, :minimumpriority)
      ["--minimumpriority", "#{min_priority}"] if min_priority
    end

    def suffixes
      suffixes = config_linter[:suffixes] || config_linter.dig(:options, :suffixes)
      ["--suffixes", "#{suffixes}"] if suffixes
    end

    def exclude
      exclude = config_linter[:exclude] || config_linter.dig(:options, :exclude)
      ["--exclude", "#{exclude}"] if exclude
    end

    def strict
      strict = config_linter[:strict] || config_linter.dig(:options, :strict)
      ["--strict"] if strict
    end

    def run_analyzer(changes, targets, rule, options)
      report_file = Tempfile.create(["phpmd-", ".xml"]).path

      # PHPMD exits 1 when some violations are found.
      # The `--ignore-violation-on-exit` will exit with a zero code, even if any violations are found.
      # See https://phpmd.org/documentation/index.html
      _stdout, stderr, status = capture3(
        analyzer_bin,
        targets,
        "xml",
        rule,
        "--ignore-violations-on-exit",
        "--report-file", report_file,
        *options
      )

      unless status.success?
        if stderr.include? "Cannot find specified rule-set"
          return Results::Failure.new(guid: guid, analyzer: analyzer, message: "Invalid rule: #{rule.inspect}")
        else
          raise stderr
        end
      end

      begin
        xml_doc = read_output_xml(report_file)
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
