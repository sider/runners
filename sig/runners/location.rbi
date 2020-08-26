class Runners::Location
  attr_reader start_line: Integer?
  attr_reader start_column: Integer?
  attr_reader end_line: Integer?
  attr_reader end_column: Integer?

  def initialize: (start_line: Integer | String,
                   ?start_column: Integer | String | nil,
                   ?end_line: Integer | String | nil,
                   ?end_column: Integer | String | nil) -> void
  def as_json: -> any
end
