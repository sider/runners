type NodeHarness::Runners::Tslint::config = {
  glob: String?,
  config: String?,
  exclude: String | Array<String> | nil,
  project: String?,

  # FIXME: How to symoblize such keys?
  "rules-dir" => String | Array<String> | nil,
  "type-check" => bool?,
}

class NodeHarness::Runners::Tslint::Processor < NodeHarness::Processor
  include NodeHarness::Nodejs

  def check_runner_config: (NodeHarness::Runners::Tslint::config) { (String, Array<String>) -> result } -> result
  def target_glob: (NodeHarness::Runners::Tslint::config) -> String
  def tslint_config: (NodeHarness::Runners::Tslint::config) -> Array<String>
  def exclude: (NodeHarness::Runners::Tslint::config) -> Array<String>
  def project: (NodeHarness::Runners::Tslint::config) -> Array<String>
  def rules_dir: (NodeHarness::Runners::Tslint::config) -> Array<String>
  def type_check: (NodeHarness::Runners::Tslint::config) -> String?
  def run_analyzer: (String, Array<String>) -> result
end

NodeHarness::Runners::Tslint::Processor::DEFAULT_DEPS: NodeHarness::Nodejs::DefaultDependencies
NodeHarness::Runners::Tslint::Processor::CONSTRAINTS: Hash<String, NodeHarness::Nodejs::Constraint>

class NodeHarness::Runners::Tslint::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<NodeHarness::Runners::Tslint::config>
end

NodeHarness::Runners::Tslint::Processor::Schema: NodeHarness::Runners::Tslint::Processor::JSONSchema
