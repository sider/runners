module Runners
  class Processor::Phpmd < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::RunnerConfig.base.update_fields { |fields|
        fields.merge!({
                        target: enum?(string, array(string)),
                        rule: string?,
                        minimumpriority: numeric?,
                        suffixes: string?,
                        exclude: string?,
                        strict: boolean?,
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

    def self.ci_config_section_name
      # Section name in sideci.yml, Generally it is the name of analyzer tool.
      "phpmd"
    end

    def analyzer
      @analyzer ||= Analyzer.new(name: "phpmd", version: analyzer_version)
    end

    def analyze(changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        prepare_analysis_files(changes)

        check_runner_config(config) do |targets, rule, options|
          run_analyzer(changes, targets, rule, options)
        end
      end
    end

    private

    def prepare_analysis_files(changes)
      delete_unchanged_files(changes, only: ["*.php"])

      trace_writer.message "Changed files:" do
        changes.changed_files.each do |file|
          trace_writer.message "  * #{file.path}"
        end
      end

      trace_writer.message "Untracked files:" do
        changes.untracked_paths.each do |path|
          trace_writer.message "  * #{path}"
        end
      end

      trace_writer.message "Existing files:" do
        capture3('find', '.')
      end
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
      # PHPMD exits 1 when some violations are found.
      # The `--ignore-violation-on-exit` will exit with a zero code, even if any violations are found.
      # See. https://phpmd.org/documentation/index.html
      commandline = [analyzer_bin, targets, 'xml', rule, '--ignore-violations-on-exit'] + options
      stdout, _ = capture3!(*commandline)

      xml_doc = REXML::Document.new(stdout)

      change_paths = changes.changed_files.map(&:path)
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

            result.add_issue Issues::Text.new(
              path: relative_path(file[:name]),
              location: loc,
              id: violation[:rule],
              message: violation.text.strip,
              links: [violation[:externalInfoUrl]]
            )
          end
        end
      end
    end
  end
end
