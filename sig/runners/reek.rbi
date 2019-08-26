class NodeHarness::Runners::Reek::Processor < NodeHarness::Processor
  include NodeHarness::Ruby

  def v4?: () -> bool
  def raise_warnings: (String) -> void
end

NodeHarness::Runners::Reek::Processor::DEFAULT_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::Reek::Processor::CONSTRAINTS: Hash<String, Array<String>>

class NodeHarness::Runners::Reek::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::Reek::Processor::Schema: NodeHarness::Runners::Reek::Processor::JSONSchema
