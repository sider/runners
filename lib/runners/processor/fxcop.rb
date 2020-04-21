module Runners
  class Processor::FxCop < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base

      let :issue, object(
        category: string,
        description: string,
        severity: string,
        )
    end

    register_config_schema(name: :fxcop, schema: Schema.runner_config)

    def analyzer_version
      ENV.fetch('FXCOP_VERSION')
    end

    def analyze(changes)
      output_file = Tempfile.create(["fxcop-", ""]).path
      capture3!('Sider.RoslynAnalyzersRunner',
        '--outputfile', output_file,
        *changes
          .changed_paths
          .select{|p| p.extname.eql?(".cs")}
          .map{|p| relative_path(working_dir / p, from: current_dir)}
          .map(&:to_s))

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        construct_result(result, read_output_json(output_file))
      end
    end

    def construct_result(result, json)
      json.each do |hash|
        path = relative_path(hash[:SourceCodeFilePath])
        hash[:Diagnostics].each do |diag|
          location = Location.new(start_line: diag.dig(:Location, :Start, :Line) + 1,
                            start_column: diag.dig(:Location, :Start, :Character) + 1,
                            end_line: diag.dig(:Location, :End, :Line) + 1,
                            end_column: diag.dig(:Location, :End, :Character) + 1)

          result.add_issue Issue.new(
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
            schema: Schema.issue,
          )
        end
      end
    end
  end
end
