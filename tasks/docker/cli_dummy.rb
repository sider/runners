require 'minitest/mock'

module Runners
  class CLI
    def initialize(**args)
    end

    def run
      Open3.capture3('sleep 10')
    end
  end
end

mock = Minitest::Mock.new
mock.expect(:called, nil)
Bugsnag.stub :notify, nil do
  mock.called
end
at_exit { mock.verify }
