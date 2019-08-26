class NodeHarness::Runners::Querly::Processor < NodeHarness::Processor
  include NodeHarness::Ruby

  def test_config_file: (Pathname) -> void
end

NodeHarness::Runners::Querly::Processor::DEFAULT_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::Querly::Processor::OPTIONAL_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::Querly::Processor::CONSTRAINTS: Hash<String, Array<String>>

class NodeHarness::Runners::Querly::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
  def rule: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::Querly::Processor::Schema: NodeHarness::Runners::Querly::Processor::JSONSchema
