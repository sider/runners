type Runners::Nodejs::npm_install_option = bool | String

module Runners::Nodejs : Processor
  def nodejs_analyzer_local_command: -> String
  def nodejs_analyzer_bin: -> String
  def package_json_path: -> Pathname
  def package_json: -> Hash<Symbol, any>
  def package_lock_json_path: -> Pathname
  def yarn_lock_path: -> Pathname
  def install_nodejs_deps: (constraints: Hash<String, Constraint>,
                            install_option: npm_install_option | nil) -> void

  # private
  def nodejs_analyzer_locally_installed?: -> bool
  def nodejs_analyzer_global_version: -> String
  def nodejs_analyzer_local_version: -> String
  def npm_install: (npm_install_option) -> void
  def yarn_install: (npm_install_option) -> void
  def list_installed_nodejs_deps: (?only: Array<String>, ?chdir: Pathname | String | nil) -> Hash<String, String>
  def check_installed_nodejs_deps: (Hash<String, Constraint>) -> void
end

Runners::Nodejs::REQUIRED_NODE_VERSIONS: Array<String>
Runners::Nodejs::REQUIRED_NPM_VERSIONS: Array<String>
Runners::Nodejs::REQUIRED_YARN_VERSIONS: Array<String>
Runners::Nodejs::INSTALL_OPTION_NONE: bool
Runners::Nodejs::INSTALL_OPTION_ALL: bool
Runners::Nodejs::INSTALL_OPTION_PRODUCTION: String
Runners::Nodejs::INSTALL_OPTION_DEVELOPMENT: String

class Runners::Nodejs::Dependency
  attr_reader name: String
  attr_reader version: String
  def initialize: (name: String, version: String) -> any
end

class Runners::Nodejs::Constraint
  def initialize: (String, *String) -> any
  def satisfied_by?: (Dependency) -> bool
  def unsatisfied_by?: (Dependency) -> bool
end
