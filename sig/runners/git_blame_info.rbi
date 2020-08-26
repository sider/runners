class Runners::GitBlameInfo
  attr_accessor commit: String
  attr_accessor original_line: Integer
  attr_accessor final_line: Integer
  attr_accessor line_hash: String

  def self.parse: (String) -> Array<instance>
  def initialize: (commit: String, original_line: Integer, final_line: Integer, line_hash: String) -> any
  def as_json: () -> Hash<Symbol, any>
end
