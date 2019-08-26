class NodeHarness::Runners::Jshint::Processor < NodeHarness::Processor
  def prepare_config: (Hash<Symbol, any>) -> void
  def jshintrc_exist?: (Hash<Symbol, any>) -> bool
  def config_path: (Hash<Symbol, any>) -> any
  def parse_result: (String) -> Array<NodeHarness::Issues::Text>
  def run_analyzer: (Hash<Symbol, any>) -> result
end

class NodeHarness::Runners::Jshint::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::Jshint::Processor::Schema: NodeHarness::Runners::Jshint::Processor::JSONSchema
