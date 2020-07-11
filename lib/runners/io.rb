module Runners
  class IO
    attr_reader :ios

    def initialize(*ios)
      @ios = ios
    end

    def write(string)
      ios.each { |io| io.write(string) }
    end

    def flush
      ios.each { |io| io.flush }
    end

    def flush!
      ios.each do |io|
        (_ = io).flush! if io.respond_to?(:flush!)
      end
    end
  end
end
