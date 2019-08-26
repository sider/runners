class NodeHarness::Runners::ScssLint::Processor < NodeHarness::Processor
  def scss_lint_version: () -> any
  def check_runner_config: (Hash<Symbol, any>) { (Array<String>) -> result } -> result
  def scss_lint_config: (Hash<Symbol, any>) -> String?
  def parse_result: (String) -> Array<NodeHarness::Issues::Text>
  def run_analyzer: (Array<String>) -> any
end

NodeHarness::Runners::ScssLint::Processor::EXIT_CODE_FILES_NOT_EXIST: Integer

class NodeHarness::Runners::ScssLint::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::ScssLint::Processor::Schema: NodeHarness::Runners::ScssLint::Processor::JSONSchema
