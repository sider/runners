module Runners
  class Location
    attr_reader :start_line
    attr_reader :start_column
    attr_reader :end_line
    attr_reader :end_column

    def initialize(start_line:, start_column: nil, end_line: nil, end_column: nil)
      @start_line = start_line ? Integer(start_line) : nil
      @start_column = start_column ? Integer(start_column) : nil
      @end_line = end_line ? Integer(end_line) : nil
      @end_column = end_column ? Integer(end_column) : nil
    end

    def ==(other)
      other.class == self.class &&
        other.start_line == start_line &&
        other.start_column == start_column &&
        other.end_line == end_line &&
        other.end_column == end_column
    end
    alias eql? ==

    def hash
      start_line.hash ^ start_column.hash ^ end_line.hash ^ end_column.hash
    end

    def as_json
      {
        start_line: start_line,
        start_column: start_column,
        end_line: end_line,
        end_column: end_column,
      }.compact
    end

    def to_s
      "{ start_line=#{start_line.inspect}, start_column=#{start_column.inspect}, end_line=#{end_line.inspect}, end_column=#{end_column.inspect} }"
    end

    def include_line?(line)
      s = start_line
      e = end_line
      case
      when s && e
        s <= line && line <= e
      when s && !e
        s == line
      else
        false
      end
    end
  end
end
