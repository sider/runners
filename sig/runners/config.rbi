class Runners::Config
  attr_reader working_dir: Pathname
  attr_reader raw_content: String?
  attr_reader content: Hash<Symbol, any>

  def initialize: (Pathname) -> any
  def raw_content!: () -> String
  def path_name: -> String
  def path_exist?: -> bool
  def ignore_patterns: -> Array<String>
  def linter: (String) -> Hash<Symbol, any>
  def linter?: (String) -> bool
  def path: -> Pathname?
  def parse_yaml: () -> String?
  def check_schema: (String?) -> Hash<Symbol, any>
end

class Runners::Config::Error < UserError
  attr_reader raw_content: String

  def initialize: (String, String) -> any
end

class Runners::Config::BrokenYAML < Config::Error
end

class Runners::Config::InvalidConfiguration < Config::Error
end

Runners::Config::CONFIG_FILE_NAME: String
Runners::Config::OLD_CONFIG_FILE_NAME: String
