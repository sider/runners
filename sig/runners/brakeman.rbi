type NodeHarness::Runners::Brakeman::config = {
}

class NodeHarness::Runners::Brakeman::Processor < NodeHarness::Processor
  include NodeHarness::Ruby

  def construct_result: (String) -> result
end

NodeHarness::Runners::Brakeman::Processor::DEFAULT_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::Brakeman::Processor::OPTIONAL_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::Brakeman::Processor::CONSTRAINTS: Hash<String, Array<String>>

class NodeHarness::Runners::Brakeman::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<NodeHarness::Runners::Brakeman::config>
end

NodeHarness::Runners::Brakeman::Processor::Schema: NodeHarness::Runners::Brakeman::Processor::JSONSchema
