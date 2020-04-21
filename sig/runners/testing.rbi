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
  def command_line: (String) -> String
  def system!: (*String) -> void
  def colored_pretty_inspect: (any) -> String

  def self.only?: (String) -> bool
  def self.add_test: (String, Hash, **any) -> void
  def self.tests: -> Hash<String, any>
end

Runners::Testing::Smoke::PROJECT_PATH: String
