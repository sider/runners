type NodeHarness::Runners::Stylelint::config = {
  config: String?,
  syntax: String?,
  quiet: bool?,
  glob: String?,

  # FIXME: How to symoblize such keys?
  "ignore-path" => String?,
  "ignore-disables" => bool?,
  "report-needless-disables" => bool?,
}

class NodeHarness::Runners::Stylelint::Processor < NodeHarness::Processor
  include NodeHarness::Nodejs

  def check_runner_config: (NodeHarness::Runners::Stylelint::config) { (String, Array<String>) -> result } -> result
  def glob: (NodeHarness::Runners::Stylelint::config) -> String
  def stylelint_config: (NodeHarness::Runners::Stylelint::config) -> String?
  def syntax: (NodeHarness::Runners::Stylelint::config) -> String?
  def ignore_path: (NodeHarness::Runners::Stylelint::config) -> String?
  def ignore_disables: (NodeHarness::Runners::Stylelint::config) -> String?
  def report_needless_disables: (NodeHarness::Runners::Stylelint::config) -> String?
  def quiet: (NodeHarness::Runners::Stylelint::config) -> String?
  def parse_result: (String) -> Array<NodeHarness::Issues::Text>
  def prepare_config_file: (NodeHarness::Runners::Stylelint::config) -> void
  def prepare_ignore_file: () -> void
  def config_file_path: (NodeHarness::Runners::Stylelint::config) -> Pathname?
  def config_file_path!: (NodeHarness::Runners::Stylelint::config) -> Pathname
  def warning_set: () -> Set<String>
  def check_warning: (Array<{ "text" => String, "reference" => String? }>) -> void
  def run_analyzer: (NodeHarness::Runners::Stylelint::config, String, Array<String>) -> result
end

NodeHarness::Runners::Stylelint::Processor::DEFAULT_DEPS: NodeHarness::Nodejs::DefaultDependencies
NodeHarness::Runners::Stylelint::Processor::CONSTRAINTS: Hash<String, NodeHarness::Nodejs::Constraint>
NodeHarness::Runners::Stylelint::Processor::DEFAULT_TARGET_FILE_EXTENSIONS: Array<String>
NodeHarness::Runners::Stylelint::Processor::DEFAULT_GLOB: String

class NodeHarness::Runners::Stylelint::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<NodeHarness::Runners::Stylelint::config>
end

NodeHarness::Runners::Stylelint::Processor::Schema: NodeHarness::Runners::Stylelint::Processor::JSONSchema
