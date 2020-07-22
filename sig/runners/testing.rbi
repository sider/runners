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
  def run_test: (TestParams, StringIO) -> Symbol
  def unify_result: (any, any, StringIO) -> bool
  def with_data_container: <'x> { () -> 'x } -> 'x
  def command_line: (params: TestParams, repo_dir: String, base: String, head: String) -> Array<String>
  def prepare_git_repository: (workdir: Pathname, smoke_target: Pathname, out: StringIO) -> Array<String>
  def debug?: () -> bool
  def debug_trace?: () -> bool
  def sh!: (*String, out: StringIO, ?exception: bool) -> [String, String]
  def colored_pretty_inspect: (any, ?multiline: bool) -> String

  def self.only?: (String) -> bool
  def self.add_test: (String, type: String,
                      ?guid: String | Symbol,
                      ?timestamp: String | Symbol,
                      ?issues: Array<Hash<Symbol, any>> | Symbol | nil,
                      ?message: String | Symbol | Regexp | nil,
                      ?analyzer: Hash<Symbol, any> | Symbol | nil,
                      ?class: String | Symbol | nil,
                      ?backtrace: Array<String> | Symbol | nil,
                      ?inspect: String | Regexp | Symbol | nil,
                      ?warnings: Array<Hash<Symbol, any>>,
                      ?ci_config: Hash<Symbol, any> | Symbol,
                      ?version: String | Symbol) -> void
  def self.add_offline_test: (String, type: String,
                              ?guid: String | Symbol,
                              ?timestamp: String | Symbol,
                              ?issues: Array<Hash<Symbol, any>> | Symbol | nil,
                              ?message: String | Symbol | Regexp | nil,
                              ?analyzer: Hash<Symbol, any> | Symbol | nil,
                              ?class: String | Symbol | nil,
                              ?backtrace: Array<String> | Symbol | nil,
                              ?inspect: String | Regexp | Symbol | nil,
                              ?warnings: Array<Hash<Symbol, any>>,
                              ?ci_config: Hash<Symbol, any> | Symbol,
                              ?version: String | Symbol) -> void
  def self.check_duplicate: (String) -> void
  def self.build_pattern: (**any) -> Hash<Symbol, any>
  def self.tests: -> Array<TestParams>
end

Runners::Testing::Smoke::PROJECT_PATH: String

class Runners::Testing::Smoke::TestParams
  attr_accessor name: String
  attr_accessor pattern: Hash<Symbol, any>
  attr_accessor offline: bool

  def initialize: (name: String, pattern: Hash<Symbol, any>, offline: bool) -> any
end
