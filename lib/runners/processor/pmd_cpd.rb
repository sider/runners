module Runners
  class Processor::PmdCpd < Processor
    include PmdCpdBase

    PmdCpdBase.register_config_schema(name: :pmd_cpd)

    def analyze(changes)
      issues = run_analyze(changes)
      Results::Success.new(guid: guid, analyzer: analyzer, issues: issues)
    end
  end
end
