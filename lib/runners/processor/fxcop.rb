module Runners
  class Processor::FxCop < Processor
    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, base

      let :issue, object(
        category: string,
        description: string,
        severity: string,
      )
    end

    register_config_schema(name: :fxcop, schema: SCHEMA.config)

    def self.config_example
      <<~'YAML'
        root_dir: project/
      YAML
    end

    def analyzer_version
      ENV.fetch('FXCOP_VERSION')
    end

    def analyze(changes)
      capture3!('Sider.RoslynAnalyzersRunner',
        '--outputfile', report_file,
        *changes
          .changed_paths
          .select{|p| p.extname.eql?(".cs")}
          .map{|p| relative_path(working_dir / p, from: current_dir)}
          .map(&:to_s))

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        construct_result(read_report_json) { |issue| result.add_issue(issue) }
      end
    end

    private

    def construct_result(json)
      json.each do |hash|
        path = relative_path(hash[:SourceCodeFilePath])
        hash[:Diagnostics].each do |diag|
          location = Location.new(start_line: diag.dig(:Location, :Start, :Line) + 1,
                            start_column: diag.dig(:Location, :Start, :Character) + 1,
                            end_line: diag.dig(:Location, :End, :Line) + 1,
                            end_column: diag.dig(:Location, :End, :Character) + 1)

          yield Issue.new(
            path: path,
            location: location,
            id: diag[:Id],
            message: diag[:Message],
            links: [diag[:HelpLinkUri]],
            object: {
              category: diag[:Category],
              description: diag[:Description],
              severity: diag[:Severity],
            },
            schema: SCHEMA.issue,
          )
        end
      end
    end
  end
end
