class NodeHarness::Runners::Misspell::Processor < NodeHarness::Processor
  def check_runner_config: (Hash<Symbol, any>) { (Array<String>, Array<String>) -> result } -> result
  def run_analyzer: (Array<String>, Array<String>) -> any
  def locale: (Hash<Symbol, any>) -> Array<String>
  def ignore: (Hash<Symbol, any>) -> Array<String>
  def analysis_targets: (Hash<Symbol, any>) -> Array<String>
  def delete_targets: (Hash<Symbol, any>) -> void
end

class NodeHarness::Runners::Misspell::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::Misspell::Processor::Schema: NodeHarness::Runners::Misspell::Processor::JSONSchema
