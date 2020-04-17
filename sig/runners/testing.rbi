class Runners::Testing::Smoke
  include Minitest::Assertions
  include UnificationAssertion
  include Tmpdir

  attr_reader argv: Array<String>
  attr_reader data_container: String
  attr_reader data_smoke_path: Pathname

  def docker_image: -> String
  def entrypoint: -> Pathname
  def expectations: -> Pathname
  def initialize: (Array<String>) -> any
  def run: () -> void
  def run_test: (String, any, IO) -> Symbol
  def unify_result: (any, any, IO) -> bool
  def with_data_container: <'x> { () -> 'x } -> 'x
  def command_line: (String, Configuration) -> String
  def system!: (*String) -> void
  def colored_pretty_inspect: (any) -> String

  def self.only?: (String) -> bool
  def self.add_test: (String, Hash, **any) { (Configuration) -> void } -> void
  def self.tests: -> Hash<String, any>
  def self.configs: -> Hash<String, Configuration>
end

Runners::Testing::Smoke::ROOT_DATA_DIR: Pathname

class Runners::Testing::Smoke::Configuration
  attr_accessor ssh_key: String?
end
