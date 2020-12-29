module Runners
  class Processor::MetricsCodeClone < Processor
    include PmdCpdBase

    register_config_schema(name: :metrics_codeclone, schema: @@BaseSchema.runner_config)

    def analyze(_changes)
      issues = run_analyze(_changes)
      Results::Success.new(guid: guid, analyzer: analyzer, issues: issues)
    end
  end
end
