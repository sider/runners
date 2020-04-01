module Runners
  # A processor class for FxCop Analyzers
  # https://docs.microsoft.com/en-us/visualstudio/code-quality/install-fxcop-analyzers
  # This is a beta release. We support only repositories that has .csproj file directly under analysis root directory.
  class Processor::FxCop < Processor
    #parameters
    RULE_ID_PATTERN = /CA[0-9]+/.freeze

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base

      let :issue, object(
        severity: string?,
        )
    end

    register_config_schema(name: :fxcop, schema: Schema.runner_config)

    def analyzer_version
      ENV.fetch('FXCOP_VERSION')
    end

    def setup
      # restore project (install dependencies)
      _, _, status = capture3('dotnet', 'restore')
      unless status.success?
        msg = <<~EOS
          Failed to restore .NET Core Project. You have to put project file (.csproj) under the analysis root. Please check the project structure and 'root_dir' parameter in #{config.path_name}.
          See: https://help.sider.review/getting-started/custom-configuration#root_dir-option
          Note: We only support a project managed with MSBuild. No support for other build systems. (e.g. Nuke, Cake)
        EOS
        return Results::Failure.new(guid: guid, message: msg, analyzer: analyzer)
      end

      # install FxCop Analyzers from nuget Repository
      capture3!('dotnet', 'add', 'package', 'Microsoft.CodeAnalysis.FxCopAnalyzers', '--version', analyzer_version)

      yield
    end

    def analyze(changes)
      # run 'dotnet build' with static analysis module
      output_file = Tempfile.create(["fxcop-", ""]).path
      capture3!('dotnet', 'build', '--no-incremental', "-property:errorlog=#{output_file}")
      output_json = read_output_json(output_file)

      # generate a result instance
      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        parse_result(output_json) do |issue|
          result.add_issue(issue)
        end
      end
    end

    # parse static analysis log from .NET Core Compilers and generate Issue instance
    # Output format is SARIF format 1.0
    # @see http://json.schemastore.org/sarif-1.0.0
    def parse_result(json)
      # parse rule information
      rules = json[:runs].each_with_object({}){|i,v| v.merge!(i[:rules])}

      # parse analysis results and return Issue instance
      by_rule = -> (res) { res[:ruleId] =~ RULE_ID_PATTERN} # filter for RuleId pattern matching
      json[:runs].each do |run|
        run[:results].filter(&by_rule).each do |result|
          # the analyzer express a target file path as 'file://' format.
          file_path = result.dig(:locations, 0, :resultFile, :uri).yield_self{|s| URI.parse(s).path}
          loc_info = result.dig(:locations,0, :resultFile, :region)

          yield Issue.new(
            path: relative_path(file_path),
            location: Location.new(
              start_line: loc_info[:startLine],
              start_column: loc_info[:startColumn],
              end_line: loc_info[:endLine],
              end_column: loc_info[:endColumn]
            ),
            id: result[:ruleId],
            message: result[:message],
            links: [rules[result[:ruleId].to_sym][:helpUri]],
            object: {
              severity: result[:level]
            },
            schema: Schema.issue
          )
        end
      end
    end
  end
end
