class NodeHarness::Runners::HamlLint::Processor < NodeHarness::Processor
  include NodeHarness::Ruby

  def setup_default_config: () -> bool
  def check_runner_config: (Hash<Symbol, any>) { (String, Array<String>) -> result } -> result
  def file: (Hash<Symbol, any>) -> String
  def include_linter: (Hash<Symbol, any>) -> String?
  def exclude_linter: (Hash<Symbol, any>) -> String?
  def exclude: (Hash<Symbol, any>) -> String?
  def haml_lint_config: (Hash<Symbol, any>) -> String?
  def parse_result: (String) -> Array<NodeHarness::Issues::Text>
  def run_analyzer: (String, Array<String>) -> result
end

NodeHarness::Runners::HamlLint::Processor::DEFAULT_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::HamlLint::Processor::OPTIONAL_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::HamlLint::Processor::CONSTRAINTS: Hash<String, Array<String>>

class NodeHarness::Runners::HamlLint::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::HamlLint::Processor::Schema: NodeHarness::Runners::HamlLint::Processor::JSONSchema
