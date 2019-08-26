class NodeHarness::Runners::Flake8::Processor < NodeHarness::Processor
  def prepare_config: () -> void
  def prepare_plugins: (Hash<Symbol, any>) -> void
  def detected_python_version: (Hash<Symbol, any>) -> String
  def specified_python_version: (Hash<Symbol, any>) -> String?
  def specified_python_version_via_pyenv: () -> String?
  def ignored_config_path: () -> Pathname
  def python_version: (Integer) -> String
  def python2_version: () -> String
  def python3_version: () -> String
  def parse_result: (String) -> Array<NodeHarness::Issues::Text>
  def run_analyzer: () -> result
end

NodeHarness::Runners::Flake8::Processor::FLAKE8_OUTPUT_FORMAT: String

class NodeHarness::Runners::Flake8::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::Flake8::Processor::Schema: NodeHarness::Runners::Flake8::Processor::JSONSchema
