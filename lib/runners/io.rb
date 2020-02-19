module Runners
  class IO
    REQUIRED_METHODS_FOR_IOS = %i[write flush].freeze

    # @dynamic ios
    attr_reader :ios

    def initialize(*ios)
      @ios = ios.each do |io|
        raise ArgumentError.new(io.inspect) unless REQUIRED_METHODS_FOR_IOS.all? { |method| io.respond_to?(method) }
      end
    end

    def write(str)
      ios.each { |io| io.write(str) }
    end

    def flush
      ios.each { |io| io.flush }
    end

    def flush!
      ios.each do |io|
        if io.respond_to?(:flush!)
          # @type var io: Runners::IO::AwsS3
          io.flush!
        end
      end
    end
  end
end
