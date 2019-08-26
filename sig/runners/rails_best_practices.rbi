class NodeHarness::Runners::RailsBestPractices::Processor < NodeHarness::Processor
  include NodeHarness::Ruby

  def check_runner_config: (Hash<Symbol, any>) { (Array<String>) -> result } -> result
  def vendor: (Hash<Symbol, any>) -> String?
  def spec: (Hash<Symbol, any>) -> String?
  def test: (Hash<Symbol, any>) -> String?
  def features: (Hash<Symbol, any>) -> String?
  def exclude: (Hash<Symbol, any>) -> String?
  def only: (Hash<Symbol, any>) -> String?
  def config: (Hash<Symbol, any>) -> String?
  def prepare_config: () -> void
  def run_analyzer: (Array<String>) -> result
end

NodeHarness::Runners::RailsBestPractices::Processor::DEFAULT_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::RailsBestPractices::Processor::OPTIONAL_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::RailsBestPractices::Processor::CONSTRAINTS: Hash<String, Array<String>>

class NodeHarness::Runners::RailsBestPractices::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::RailsBestPractices::Processor::Schema: NodeHarness::Runners::RailsBestPractices::Processor::JSONSchema
