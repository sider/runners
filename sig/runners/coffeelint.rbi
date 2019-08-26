type NodeHarness::Runners::Coffeelint::config = {
  file: String?,
}

class NodeHarness::Runners::Coffeelint::Processor < NodeHarness::Processor
  include NodeHarness::Nodejs

  def check_runner_config: (NodeHarness::Runners::Coffeelint::config) { (Array<String>) -> result } -> result
  def coffeelint_config: (NodeHarness::Runners::Coffeelint::config) -> Array<String>
  def file: (NodeHarness::Runners::Coffeelint::config) -> Array<String>
  def run_analyzer: (Array<String>) -> result
end

NodeHarness::Runners::Coffeelint::Processor::DEFAULT_DEPS: NodeHarness::Nodejs::DefaultDependencies
NodeHarness::Runners::Coffeelint::Processor::CONSTRAINTS: Hash<String, NodeHarness::Nodejs::Constraint>

class NodeHarness::Runners::Coffeelint::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<NodeHarness::Runners::Coffeelint::config>
end

NodeHarness::Runners::Coffeelint::Processor::Schema: NodeHarness::Runners::Coffeelint::Processor::JSONSchema
