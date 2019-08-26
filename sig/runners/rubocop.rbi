class NodeHarness::Runners::RuboCop::Processor < NodeHarness::Processor
  include NodeHarness::Ruby

  def check_runner_config: (Hash<Symbol, any>) { (Array<String>) -> result } -> result
  def rails_option: (Hash<Symbol, any>) -> String?
  def config_file: (Hash<Symbol, any>) -> String?
  def safe: (Hash<Symbol, any>) -> String?
  def setup_default_config: () -> bool
  def check_rubocop_yml_warning: (String) -> void
  def run_analyzer: (Array<String>) -> result
  def rails_cops_removed?: () -> bool
end

NodeHarness::Runners::RuboCop::Processor::DefaultConfig: String
NodeHarness::Runners::RuboCop::Processor::DEFAULT_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::RuboCop::Processor::OPTIONAL_GEMS: Array<NodeHarness::Ruby::GemInstaller::Spec>
NodeHarness::Runners::RuboCop::Processor::CONSTRAINTS: Hash<String, Array<String>>

class NodeHarness::Runners::RuboCop::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::RuboCop::Processor::Schema: NodeHarness::Runners::RuboCop::Processor::JSONSchema
