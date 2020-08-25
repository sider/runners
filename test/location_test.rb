require "test_helper"

class LocationTest < Minitest::Test
  Location = Runners::Location

  def test_as_json
    loc = Location.new(start_line: 1, start_column: 1, end_line: 3, end_column: 2)
    assert_equal({ start_line: 1, start_column: 1, end_line: 3, end_column: 2 }, loc.as_json)

    loc = Location.new(start_line: 1, start_column: nil, end_line: 3, end_column: nil)
    assert_equal({ start_line: 1, end_line: 3 }, loc.as_json)
  end

  def test_from_json
    assert_equal Location.new(start_line: 1, start_column: nil, end_line: 3, end_column: nil),
                 Location.from_json({ start_line: 1, end_line: 3 })
  end
end
