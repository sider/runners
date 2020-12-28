module Runners
  class Processor::MetricsCodeClone < Processor
    include PmdCpdBase

    register_config_schema(name: :metrics_codeclone, schema: @@Schema.runner_config)
  end
end
