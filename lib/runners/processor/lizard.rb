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
      # With --verbose and --csv flags, lizard writes results as following format:
      # NLOC,CCN,token,PARAM,length,location,file,function,long_name,start,end

      nloc = Integer(row["NLOC"])
      ccn = Integer(row["CCN"])
      function = row["function"]
      msg = "Complexity is #{ccn} for #{nloc} line(s) of code at #{function}."

      result.add_issue Issue.new(
        path: relative_path(row["file"]),
        location: Location.new(start_line: row["start"], end_line: row["end"]),
        id: "code-metrics",
        message: msg,
        object: {
          NLOC: nloc,
          CCN: ccn,
          token: Integer(row["token"]),
          PARAM: Integer(row["PARAM"]),
          length: Integer(row["length"]),
          function: function,
          long_name: row["long_name"],
          },
        schema: Schema.issue,
        )
    end
  end
end
