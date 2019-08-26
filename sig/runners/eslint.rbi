type NodeHarness::Runners::Eslint::config = {
  dir: String | Array<String> | nil,
  ext: String?,
  config: String?,
  global: String?,
  quiet: bool?,

  # FIXME: How to symoblize such keys?
  "ignore-path" => String?,
  "ignore-pattern" => String | Array<String> | nil,
  "no-ignore" => bool?,
}

type NodeHarness::Runners::Eslint::eslint_result = {
  ruleId: String,
  message: String,
  line: String,
  severity: Integer,
}

class NodeHarness::Runners::Eslint::Processor < NodeHarness::Processor
  include NodeHarness::Nodejs

  def check_runner_config: (NodeHarness::Runners::Eslint::config) { (Array<String>, Array<String>) -> result } -> result
  def dir: (NodeHarness::Runners::Eslint::config) -> Array<String>
  def eslint_config: (NodeHarness::Runners::Eslint::config) -> String?
  def user_specified_eslint_config_path: (NodeHarness::Runners::Eslint::config) -> String?
  def ext: (NodeHarness::Runners::Eslint::config) -> String?
  def ignore_path: (NodeHarness::Runners::Eslint::config) -> String?
  def ignore_pattern: (NodeHarness::Runners::Eslint::config) -> Array<String>
  def no_ignore: (NodeHarness::Runners::Eslint::config) -> String?
  def global: (NodeHarness::Runners::Eslint::config) -> String?
  def quiet: (NodeHarness::Runners::Eslint::config) -> String?
  def severity_hander: (NodeHarness::Runners::Eslint::eslint_result) -> String
  def issue_parameters: <'x> (NodeHarness::Runners::Eslint::eslint_result) { (Integer, String, String) -> 'x } -> 'x
  def parse_result: (String) -> Array<NodeHarness::Issues::Text>
  def run_analyzer: (Array<String>, Array<String>) -> result
end

NodeHarness::Runners::Eslint::Processor::DEFAULT_DEPS: NodeHarness::Nodejs::DefaultDependencies
NodeHarness::Runners::Eslint::Processor::CONSTRAINTS: Hash<String, NodeHarness::Nodejs::Constraint>

class NodeHarness::Runners::Eslint::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<NodeHarness::Runners::Eslint::config>
end

NodeHarness::Runners::Eslint::Processor::Schema: NodeHarness::Runners::Eslint::Processor::JSONSchema
