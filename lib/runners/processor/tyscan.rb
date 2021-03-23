module Runners
  class Processor::Tyscan < Processor
    include Nodejs

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, npm(
        config: string?,
        tsconfig: string?,
        target: target,
        paths: target, # alias for `target`
      )

      let :issue, object(
        id: string,
        message: string,
      )
    end

    register_config_schema(name: :tyscan, schema: SCHEMA.config)

    CONSTRAINTS = {
      "tyscan" => Gem::Requirement.new(">= 0.2.1", "< 1.0.0").freeze,
    }.freeze

    DEFAULT_CONFIG_FILE = "tyscan.yml".freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        dependencies:
          - my-tyscan-plugin@2
        npm_install: false
        config: config/tyscan.yml
        tsconfig: src/tsconfig.json
        target: [src/]
      YAML
    end

    def setup
      if !config_linter[:config] && !File.exist?(DEFAULT_CONFIG_FILE)
        return missing_config_file_result(DEFAULT_CONFIG_FILE)
      end

      begin
        install_nodejs_deps constraints: CONSTRAINTS
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message)
      end

      yield
    end

    def analyze(_)
      tyscan_test
      tyscan_scan
    end

    private

    def tyscan_test
      args = []
      args << "-t" << config_linter[:tsconfig] if config_linter[:tsconfig]
      args << "-c" << config_linter[:config] if config_linter[:config]

      _, _, status = capture3(nodejs_analyzer_bin, "test", *args)

      if status.nil? || !status.success?
        msg = "`tyscan test` failed. It may cause an unintended match."
        add_warning(msg, file: config_linter[:config] || DEFAULT_CONFIG_FILE)
      end
    end

    def tyscan_scan
      args = []
      args << "-t" << config_linter[:tsconfig] if config_linter[:tsconfig]
      args << "-c" << config_linter[:config] if config_linter[:config]
      args += Array(config_linter[:target] || config_linter[:paths])

      stdout, _stderr, status = capture3(nodejs_analyzer_bin, "scan", "--json", *args)

      # TyScan exited with 0 when finishing an analysis correctly.
      unless status.exitstatus == 0
        return Results::Failure.new(guid: guid, analyzer: analyzer)
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
            schema: SCHEMA.issue,
          )
        end
      end
    end
  end
end
