module Runners
  class Processor::LineCounter < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.base
      let :metrics, object(
          line_of_code: integer
      )
    end

    register_config_schema(name: :linecounter, schema: Schema.runner_config)

    def analyzer_bin
      "wc"
    end

    def analyzer_version
      stdout, _, _ = capture3!(analyzer_bin, "--version")
      stdout.split(/\R/)[0][/\d*\.\d*/]
    end

    def analyze(changes)
      stdout, _, status = capture3!(analyzer_bin, *analyzer_options, *changes.changed_paths.map(&:to_s))

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        stdout.split(/\R/).each do |line|
          parsed = line.strip.split(' ', 2)
          result.add_metric Metric.new(
              path: Pathname(parsed[1]),
              type: "physical_loc",
              object: { loc: parsed[0].to_i }
          )
        end
      end
    end

    private

    def analyzer_options
      ["-l"]
    end
  end
end


