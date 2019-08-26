type NodeHarness::Runners::CodeSniffer::config = {
  version: String | Float | Integer | nil,
  dir: String?,
  standard: String?,
  extensions: String?,
  encoding: String?,
  ignore: String?,
}

type NodeHarness::Runners::CodeSniffer::default_options = {
  "options" => {
    "standard" => String,
    "extensions" => String,
  },
  "dir" => String,
}

class NodeHarness::Runners::CodeSniffer::Processor < NodeHarness::Processor
  attr_reader phpcs_bin: String

  def check_runner_config: (NodeHarness::Runners::CodeSniffer::config) { (String, Array<String>, String) -> result } -> result
  def additional_options: (NodeHarness::Runners::CodeSniffer::config) -> Array<String>
  def standard_option: (NodeHarness::Runners::CodeSniffer::config) -> String
  def extensions_option: (NodeHarness::Runners::CodeSniffer::config) -> String
  def encoding_option: (NodeHarness::Runners::CodeSniffer::config) -> String?
  def ignore_option: (NodeHarness::Runners::CodeSniffer::config) -> String?
  def directory: (NodeHarness::Runners::CodeSniffer::config) -> String
  def default_sideci_options: () -> NodeHarness::Runners::CodeSniffer::default_options
  def php_framework: () -> String?
  def print_large_string: (String) -> void
  def run_analyzer: (String, Array<String>, String) -> result
end

class NodeHarness::Runners::CodeSniffer::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<NodeHarness::Runners::CodeSniffer::config>
end

NodeHarness::Runners::CodeSniffer::Processor::Schema: NodeHarness::Runners::CodeSniffer::Processor::JSONSchema
