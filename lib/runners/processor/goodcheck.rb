module Runners
  class Processor::Goodcheck < Processor
    include Ruby

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

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

    GEM_NAME = "goodcheck".freeze
    CONSTRAINTS = {
      GEM_NAME => Gem::Requirement.new(">= 1.0.0", "< 3.0.0").freeze,
    }.freeze

    DEFAULT_TARGET = ".".freeze
    DEFAULT_CONFIG_FILE = "goodcheck.yml".freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        config: config/goodcheck.yml
        target:
          - src/
          - test/
      YAML
    end

    def extract_version_option
      "version"
    end

    def goodcheck_test
      # NOTE: Suppress Ruby 2.7 warning to prevent `stderr` from getting dirty.
      #       See https://www.ruby-lang.org/en/news/2019/12/25/ruby-2-7-0-released
      stdout, stderr, status = push_env_hash({ "RUBYOPT" => "-W:no-deprecated" }) do
        cmd = ruby_analyzer_command("test", *option_config_file)
        capture3(cmd.bin, *cmd.args)
      end

      if !status.success? && !stdout.empty?
        config_file = config_linter[:config] || DEFAULT_CONFIG_FILE
        add_warning "Validating your Goodcheck configuration file `#{config_file}` failed.", file: config_file
      end

      if !status.success? && !stderr.empty?
        stderr.lines(chomp: true).first
      else
        nil
      end
    end

    def goodcheck_check
      targets = Array(config_linter[:target] || DEFAULT_TARGET)
      cmd = ruby_analyzer_command("check", "--format=json", *option_config_file, *targets)
      stdout, stderr, _ = capture3(cmd.bin, *cmd.args)

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
      install_gems(default_gem_specs(GEM_NAME), constraints: CONSTRAINTS) { yield }
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(changes)
      # NOTE: This check should be called after installing gems.
      if !config_linter[:config] && !File.exist?(DEFAULT_CONFIG_FILE)
        return missing_config_file_result(DEFAULT_CONFIG_FILE)
      end

      delete_unchanged_files(changes, except: ["*.yml", "*.yaml"])

      error_message = goodcheck_test
      if error_message
        Results::Failure.new(guid: guid, analyzer: analyzer, message: error_message)
      else
        goodcheck_check
      end
    end

    private

    def option_config_file
      config = config_linter[:config]
      config ? ["--config", config] : []
    end
  end
end
