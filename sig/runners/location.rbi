type Runners::Location::json_key = :start_line | :start_column | :end_line | :end_column

class Runners::Location
  attr_reader start_line: Integer?
  attr_reader start_column: Integer?
  attr_reader end_line: Integer?
  attr_reader end_column: Integer?

  def initialize: (start_line: Integer | String,
                   ?start_column: Integer | String | nil,
                   ?end_line: Integer | String | nil,
                   ?end_column: Integer | String | nil) -> void
  def as_json: -> Hash<json_key, Integer>
  def self.from_json: (any) -> Location
end

class Runners::Location::InvalidLocationError < StandardError
  attr_reader location: Location

  def initialize: (location: Location) -> any
end
