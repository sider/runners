module Runners
  class IO
    attr_reader :ios

    def initialize(*ios)
      @ios = ios
    end

    def write(*args)
      ios.each { |io| io.write(*args) }
    end

    def flush
      ios.each { |io| io.flush }
    end

    def flush!
      ios.each do |io|
        if io.respond_to?(:flush!)
          # @type var io: io
          io.flush!
        end
      end
    end
  end
end
