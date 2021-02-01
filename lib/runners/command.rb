module Runners
  class Command
    attr_reader :bin
    attr_reader :args

    def initialize(bin, args = [])
      @bin = bin
      @args = args
    end

    def to_a
      [bin, *args]
    end
  end
end
