module Runners
  class Processor::Tyscan < Processor
    include Nodejs

    # Define schema in sider.yml
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.npm.update_fields { |fields|
        fields.merge!({
                        config: string?,
                        tsconfig: string?,
                        paths: array?(string),
                      })
      }

      let :issue_object, object(
        id: string,
        message: string,
      )
    end

    register_config_schema(name: :tyscan, schema: Schema.runner_config)

    DEFAULT_DEPS = DefaultDependencies.new(
      main: Dependency.new(name: "tyscan", version: "0.3.1"),
      extras: [
        Dependency.new(name: "typescript", version: "3.7.2"),
      ],
    ).freeze

    CONSTRAINTS = {
      "tyscan" => Constraint.new(">= 0.2.1", "< 1.0.0")
    }.freeze

    DEFAULT_CONFIG_NOT_FOUND_ERROR = <<~MESSAGE.freeze
      `tyscan.yml` does not exist in your repository.

      To start performing analysis, `tyscan.yml` is required.
      See also: https://help.sider.review/tools/javascript/tyscan
    MESSAGE

    def self.ci_config_section_name
      'tyscan'
    end

    def analyzer_name
      "TyScan"
    end

    def setup
      ensure_runner_config_schema(Schema.runner_config) do |config|
        if !(current_dir + 'tyscan.yml').exist? && config[:config].nil?
          trace_writer.error DEFAULT_CONFIG_NOT_FOUND_ERROR
          add_warning DEFAULT_CONFIG_NOT_FOUND_ERROR
          return Results::Success.new(guid: guid, analyzer: analyzer)
        end

        begin
          install_nodejs_deps(DEFAULT_DEPS, constraints: CONSTRAINTS, install_option: config[:npm_install])
        rescue UserError => exn
          return Results::Failure.new(guid: guid, message: exn.message)
        end

        yield
      end
    end

    def analyze(_)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        tyscan_test(config)
        tyscan_scan(config)
      end
    end

    def tyscan_test(config)
      args = []
      args.unshift("-t", config[:tsconfig]) if config[:tsconfig]
      args.unshift("-c", config[:config]) if config[:config]

      _, _, status = capture3(nodejs_analyzer_bin, "test", *args)

      if status.nil? || !status.success?
        msg = <<~MESSAGE.chomp
          `tyscan test` failed. It may cause an unintended match.
        MESSAGE
        add_warning(msg, file: config[:config] || "tyscan.yml")
      end
    end

    def tyscan_scan(config)
      args = []
      args.unshift(*config[:paths]) if config[:paths]
      args.unshift("-t", config[:tsconfig]) if config[:tsconfig]
      args.unshift("-c", config[:config]) if config[:config]

      stdout, stderr, status = capture3(nodejs_analyzer_bin, "scan", "--json", *args)

      # TyScan exited with 0 when finishing an analysis correctly.
      unless status.exitstatus == 0
        return Results::Failure.new(guid: guid, message: <<~MESSAGE, analyzer: analyzer)
          TyScan was failed with status #{status.exitstatus} since an unexpected error occurred.

          STDERR:
          #{stderr}
        MESSAGE
      end

      json = JSON.parse(stdout, symbolize_names: true)

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        json[:matches].each do |match|
          result.add_issue Issue.new(
            id: match[:rule][:id],
            path: relative_path(match[:path]),
            location: Location.new(
              start_line: match[:location][:start][0],
              start_column: match[:location][:start][1],
              end_line: match[:location][:end][0],
              end_column: match[:location][:end][1],
            ),
            message: match[:rule][:message],
            object: {
              id: match[:rule][:id],
              message: match[:rule][:message],
            },
            schema: Schema.issue_object,
          )
        end
      end
    end
  end
end
