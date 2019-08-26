type NodeHarness::Runners::Goodcheck::config = {
  config: String?,
  target: String | Array<String> | nil,
}

class NodeHarness::Runners::Goodcheck::Processor < NodeHarness::Processor
  include NodeHarness::Ruby

  def config_option: (NodeHarness::Runners::Goodcheck::config) -> Array<String>
  def ensure_config: { (NodeHarness::Runners::Goodcheck::config) -> result } -> result
  def goodcheck_test: (NodeHarness::Runners::Goodcheck::config) { () -> result } -> result
  def goodcheck_check: (NodeHarness::Runners::Goodcheck::config) -> result
end

NodeHarness::Runners::Goodcheck::Processor::DEFAULT_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::Goodcheck::Processor::OPTIONAL_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::Goodcheck::Processor::CONSTRAINTS: Hash<String, Array<String>>

class NodeHarness::Runners::Goodcheck::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<NodeHarness::Runners::Goodcheck::config>
end

NodeHarness::Runners::Goodcheck::Processor::Schema: NodeHarness::Runners::Goodcheck::Processor::JSONSchema
