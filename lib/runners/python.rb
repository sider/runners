module Runners
  module Python
    class PipInstallFailed < UserError; end

    def show_runtime_versions
      capture3! "python", "--version"
      capture3! "pip", "--version"
      capture3! "pipenv", "--version"
    end

    # @see https://pip.pypa.io/en/stable/reference/pip_install
    # @see https://pip.pypa.io/en/stable/reference/pip_list
    def pip_install(*packages)
      unless packages.empty?
        options = %w[--disable-pip-version-check]

        begin
          # NOTE: Use `--only-binary` to prevent malicious dependency's code execution.
          capture3! "pip", "install", "--quiet", "--only-binary", ":all:", *options, *packages
        rescue Runners::Shell::ExecError
          raise PipInstallFailed, "Install failed: #{packages.join(', ')}"
        end

        capture3! "pip", "list", "--verbose", *options
      end
    end
  end
end
