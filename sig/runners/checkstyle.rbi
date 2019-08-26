class NodeHarness::Runners::Checkstyle::Processor < NodeHarness::Processor
  def checkstyle_args: (*String, config: String?, format: Symbol, excludes: Array<Hash<Symbol, String>>?, properties: String?) -> Array<String>
  def jar_path: () -> String
  def checkstyle: (*any, ?config: any, ?format: any, ?excludes: any, ?properties: any) -> any
  def checkstyle!: (*any, ?config: any, ?format: any, ?excludes: any, ?properties: any) -> any
  def construct_result: (any, any) -> any
  def configuration: () -> Hash<Symbol, any>
  def config_file: () -> String
  def check_directory: () -> Array<String>
  def excluded_directories: () -> Array<Hash<Symbol, String>>
  def properties_file: () -> String?
  def locale: () -> Locale::Tag
  def ignored_severities: () -> Array<String>
  def array: <'x> ('x) -> Array<'x>
end

class NodeHarness::Runners::Checkstyle::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<any>
end

NodeHarness::Runners::Checkstyle::Processor::Schema: NodeHarness::Runners::Checkstyle::Processor::JSONSchema
