class NodeHarness::Runners::PmdJava::Processor < NodeHarness::Processor
  def pmd_path: () -> Pathname
  def pmd: (dir: String, rulesets: Array<String>, encoding: String?, min_priority: Numeric?) -> [String, String, Process::Status]
  def run_analyzer: (String, Array<String>, String?, Numeric?) -> result
  def construct_result: (result, String, String) -> void
  def check_runner_config: (Hash<Symbol, any>) { (String, Array<String>, String?, Numeric?) -> result } -> result
  def rulesets: (Hash<Symbol, any>) -> Array<String>
  def check_directory: (Hash<Symbol, any>) -> String
  def encoding: (Hash<Symbol, any>) -> String?
  def min_priority: (Hash<Symbol, any>) -> Numeric?
  def array: <'x> ('x) -> Array<'x>
end

class NodeHarness::Runners::PmdJava::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::PmdJava::Processor::Schema: NodeHarness::Runners::PmdJava::Processor::JSONSchema
