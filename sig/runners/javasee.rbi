class NodeHarness::Runners::Javasee::Processor < NodeHarness::Processor
  def javasee: () -> String
  def javasee_check: (dirs: Array<Pathname>, config_path: Pathname) -> [String, String, Process::Status]
  def construct_result: (result, String, String) -> result
  def check_runner_config: (Hash<Symbol, any>) { (Array<Pathname>, Pathname) -> result } -> result
end

class NodeHarness::Runners::Javasee::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::Javasee::Processor::Schema: NodeHarness::Runners::Javasee::Processor::JSONSchema
