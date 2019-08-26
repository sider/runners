module NodeHarness
  class Location
    class InvalidLocationError < StandardError
      # @dynamic location
      attr_reader :location

      def initialize(location:)
        @location = location
      end
    end

    attr_reader :start_line
    attr_reader :start_column
    attr_reader :end_line
    attr_reader :end_column

    def initialize(start_line:, start_column:, end_line:, end_column:)
      @start_line = start_line
      @start_column = start_column
      @end_line = end_line
      @end_column = end_column
    end

    def ==(other)
      other.class == self.class &&
        other.start_line == start_line &&
        other.start_column == start_column &&
        other.end_line == end_line &&
        other.end_column == end_column
    end

    def hash
      start_line.hash ^ start_column.hash ^ end_line.hash ^ end_column.hash
    end

    def eql?(other)
      self == other
    end

    def valid?
      case
      when start_line && !start_column && !end_line && !end_column
        # Valid when only start_line is specified
        true
      when start_line && !start_column && end_line && !end_column
        # Valid when only start_line and end_line are specified
        true
      when start_line && start_column && end_line && end_column
        # Valid when every attributes are specified
        true
      end
    end

    # @type method ensure_validity: ?{ (self) -> any } -> any
    def ensure_validity
      raise InvalidLocationError.new(location: self) unless valid?

      if block_given?
        yield self
      else
        self
      end
    end

    def self.from_json(json)
      self.new(start_line: json[:start_line],
               start_column: json[:start_column],
               end_line: json[:end_line],
               end_column: json[:end_column]).ensure_validity
    end

    def as_json
      ensure_validity do
        {}.tap do |json|
          json[:start_line] = start_line
          json[:start_column] = start_column if start_column
          json[:end_line] = end_line if end_line
          json[:end_column] = end_column if end_column
        end
      end
    end
  end
end
