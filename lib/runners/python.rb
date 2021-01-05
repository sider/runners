module Runners
  module Python
    def show_runtime_versions
      capture3! "python", "--version"
      capture3! "pip", "--version"
      capture3! "pipenv", "--version"
    end

    def pip_install(*packages)
      unless packages.empty?
        options = %w[--disable-pip-version-check]
        capture3! "pip", "install", "--quiet", *options, *packages
        capture3! "pip", "list", "--verbose", *options
      end
    end
  end
end
