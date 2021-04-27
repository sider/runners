module Runners
  module Go
    def show_runtime_versions
      capture3! "go", "version"
      super
    end
  end
end
