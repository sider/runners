module Runners
  class Processor::Coffeelint < Processor
    include Nodejs

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, npm(
        file: string?,
      )
    end

    register_config_schema SCHEMA.config

    CONSTRAINTS = {
      "@coffeelint/cli" => Gem::Requirement.new(">= 4.0.0", "< 6.0.0").freeze,
    }.freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        dependencies:
          - my-coffeelint-plugin@2
        npm_install: false
        file: config/coffeelint.json
      YAML
    end

    def setup
      begin
        install_nodejs_deps constraints: CONSTRAINTS
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
      end

      yield
    end

    def analyze(_changes)
      # NOTE: CoffeeLint exits with 1 when any issues exist.
      stdout, stderr, _status = capture3(nodejs_analyzer_bin, '.', '--reporter', 'raw', *config_file)

      unless stderr.empty?
        return Results::Failure.new(guid: guid, analyzer: analyzer)
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        JSON.parse(stdout, symbolize_names: true).each do |file, issues|
          path = relative_path(file.to_s)
          issues.each do |issue|
            message = issue[:message].dup
            message << " #{issue[:context]}" if issue[:context]
            result.add_issue Issue.new(
              path: path,
              location: Location.new(start_line: issue[:lineNumber]),
              id: issue[:rule] || issue[:name],
              message: message,
            )
          end
        end
      end
    end

    private

    def config_file
      file = config_linter[:file]
      file ? ['--file', file] : []
    end
  end
end
