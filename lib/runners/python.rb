module Runners
  module Python
    class PipInstallFailed < UserError; end

    def show_runtime_versions
      capture3! "python", "--version"
      capture3! "pip", "--version"
      capture3! "pipenv", "--version"
      super
    end

    # @see https://pip.pypa.io/en/stable/reference/pip_install
    # @see https://pip.pypa.io/en/stable/reference/pip_list
    def pip_install(dependencies = Array(config_linter[:dependencies]))
      return if dependencies.empty?

      # @type var dependencies: Array[String | { name: String, version: String }]
      deps = dependencies.map do |dep|
        case dep
        when Hash
          dep.fetch(:name) + dep.fetch(:version)
        else
          dep
        end
      end

      options = %w[--disable-pip-version-check]
      begin
        # NOTE: Use `--only-binary` to prevent malicious dependency's code execution.
        capture3! "pip", "install", "--quiet", "--only-binary", ":all:", *options, *deps
      rescue Runners::Shell::ExecError
        msg = deps.map { |dep| "`#{dep}`" }.join(", ")
        raise PipInstallFailed, "`pip install` failed: #{msg}"
      end

      capture3! "pip", "list", "--verbose", *options
    end
  end
end
