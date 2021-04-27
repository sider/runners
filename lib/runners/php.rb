module Runners
  module PHP
    def show_runtime_versions
      capture3! "php", "-version"
      capture3! "composer", "--version"
      capture3! "composer", "global", "info"
      super
    end
  end
end
