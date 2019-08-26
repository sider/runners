class NodeHarness::Runners::Phinder::Processor < NodeHarness::Processor
  def test_phinder_config: (Hash<Symbol, any>) -> void
  def run_phinder: (Hash<Symbol, any>) -> result
  def ensure_phinder_config_files: (*Pathname) { (Pathname) -> result } -> result
end

class NodeHarness::Runners::Phinder::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::Phinder::Processor::Schema: NodeHarness::Runners::Phinder::Processor::JSONSchema
