require "etc"

module Runners
  class Processor::Lizard < Processor
    include Python

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base

      let :issue, object(
        NLOC: integer,
        CCN: integer,
        token: integer,
        PARAM: integer,
        length: integer,
        function: string,
        long_name: string,
        )
    end

    register_config_schema(name: :lizard, schema: Schema.runner_config)

    def analyze(changes)
      delete_unchanged_files(changes)

      capture3!(analyzer_bin,
        '--working_threads', Etc.nprocessors.to_s,
        '--verbose',
        '--csv',
        '-o', report_file,
        '.')

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        read_report_csv(report_file, headers: true) do |row|
          construct_result(result, row)
        end
      end
    end

    private

    def construct_result(result, row)
      result.add_issue Issue.new(
        path: relative_path(row["file"]),
        location: Location.new(start_line: row["start"], end_line: row["end"]),
        id: "TBD",
        message: "TBD",
        object: {
          NLOC: Integer(row["NLOC"]),
          CCN: Integer(row["CCN"]),
          token: Integer(row["token"]),
          PARAM: Integer(row["PARAM"]),
          length: Integer(row["length"]),
          function: row["function"],
          long_name: row["long_name"],
          },
        schema: Schema.issue,
        )
    end
  end
end
