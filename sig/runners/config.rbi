class Runners::Config
  attr_reader working_dir: Pathname
  attr_reader input_string: String?
  attr_reader content: Hash<Symbol, any>

  def initialize: (Pathname) -> any
  def path_name: -> String
  def path_exist?: -> bool
  def ignore: -> Array<String>
  def linter: (String) -> Hash<Symbol, any>
  def path: -> Pathname?
  def parse_yaml: () -> String?
  def check_schema: (String?) -> Hash<Symbol, any>
end

class Runners::Config::BrokenYAML < UserError
end

class Runners::Config::InvalidConfiguration < UserError
  attr_reader input_string: String?

  def initialize: (String, String?) -> any
end

Runners::Config::CONFIG_FILE_NAME: String
Runners::Config::OLD_CONFIG_FILE_NAME: String
