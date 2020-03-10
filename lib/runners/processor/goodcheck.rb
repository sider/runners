module Runners
  class Processor::Goodcheck < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :rule, object(
        id: string,
        message: string,
        justifications: array(string),
      )

      let :runner_config, Schema::BaseConfig.ruby.update_fields { |fields|
        fields.merge!({
                        config: string?,
                        target: optional(enum(string, array(string)))
                      })
      }.freeze
    end

    register_config_schema(name: :goodcheck, schema: Schema.runner_config)

    CONSTRAINTS = {
      "goodcheck" => [">= 1.0.0", "< 3.0"]
    }.freeze

    def analyzer_version
      @analyzer_version ||= extract_version! ruby_analyzer_bin, "version"
    end

    def goodcheck_config_file
      @goodcheck_config_file ||= config_linter[:config] || "goodcheck.yml"
    end

    def cli_options(*additional_args)
      [
        config_linter[:config]&.yield_self { |config| "--config=#{config}"},
      ].compact + additional_args
    end

    def goodcheck_test
      stdout, stderr, status = capture3(*ruby_analyzer_bin, "test", *cli_options)

      if !status.success? && !stdout.empty?
        msg = "The validation of your Goodcheck configuration file failed. Check the output of `goodcheck test` command."
        add_warning(msg, file: goodcheck_config_file)
      end

      if !status.success? && !stderr.empty?
        stderr.lines.first.chomp
      else
        nil
      end
    end

    def goodcheck_check
      targets = Array(config_linter[:target]) || ["."]
      stdout, stderr, _ = capture3(*ruby_analyzer_bin, "check", "--format=json", *cli_options(*targets))

      json = JSON.parse(stdout, symbolize_names: true)

      stderr.each_line do |line|
        case line
        when /\[Warning\] (.+)$/
          add_warning $1
        end
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        json.each do |hash|
          id = hash[:rule_id]
          path = relative_path(hash[:path])

          # When the `not` rule detects issues, `location` is null.
          # @see https://github.com/sider/goodcheck/pull/49/files#r281913022
          if hash[:location]
            location = Location.new(
              start_line: hash[:location][:start_line],
              start_column: hash[:location][:start_column],
              end_line: hash[:location][:end_line],
              end_column: hash[:location][:end_column],
            )
          else
            location = nil
          end

          object = {
            id: id,
            message: hash[:message],
            justifications: hash[:justifications]
          }

          issue = Issue.new(
            path: path,
            location: location,
            id: id,
            message: hash[:message],
            object: object,
            schema: Schema.rule
          )

          result.add_issue issue
        end
      end
    end

    def setup
      ret = install_gems default_gem_specs, constraints: CONSTRAINTS do
        analyzer
        yield
      end

      # NOTE: Exceptionally MissingFileFailure is treated as successful
      if ret.instance_of? Results::MissingFilesFailure
        trace_writer.error "File not found: goodcheck.yml"
        add_warning(<<~MESSAGE)
          Sider cannot find the required configuration file `goodcheck.yml`.
          Please set up Goodcheck by following the instructions, or you can disable it in the repository settings.

          - https://github.com/sider/goodcheck
          - #{analyzer_doc}
        MESSAGE
        Results::Success.new(guid: guid, analyzer: analyzer)
      else
        ret
      end
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(changes)
      delete_unchanged_files(changes, except: ["*.yml", "*.yaml"])

      ensure_files(relative_path(goodcheck_config_file)) do
        error_message = goodcheck_test
        if error_message
          Results::Failure.new(guid: guid, analyzer: analyzer, message: error_message)
        else
          goodcheck_check
        end
      end
    end
  end
end
