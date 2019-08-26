class NodeHarness::Runners::Phpmd::Processor < NodeHarness::Processor
  def prepare_analysis_files: (Changes) -> void
  def check_runner_config: (Hash<Symbol, any>) { (String, String, Array<String>) -> result } -> result
  def rule: (Hash<Symbol, any>) -> String
  def target_dirs: (Hash<Symbol, any>) -> String
  def minimumpriority: (Hash<Symbol, any>) -> Array<String>
  def suffixes: (Hash<Symbol, any>) -> Array<String>
  def exclude: (Hash<Symbol, any>) -> Array<String>
  def strict: (Hash<Symbol, any>) -> Array<String>
  def run_analyzer: (Changes, String, String, Array<String>) -> any
end

class NodeHarness::Runners::Phpmd::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::Phpmd::Processor::Schema: NodeHarness::Runners::Phpmd::Processor::JSONSchema
