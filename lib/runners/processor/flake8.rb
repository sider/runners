module Runners
  class Processor::Flake8 < Processor
    include Python

    SCHEMA = _ = StrongJSON.new do
      extend Schema::ConfigTypes

      # @type self: SchemaClass
      let :config, python(
        target: target,
        config: string?,
        plugins: dependencies, # alias
        parallel: boolean?,
      )
    end

    register_config_schema SCHEMA.config

    DEFAULT_TARGET = ".".freeze
    DEFAULT_CONFIG_PATH = (Pathname(Dir.home) / '.config' / 'flake8').to_path.freeze
    DEFAULT_IGNORED_CONFIG_PATH = (Pathname(Dir.home) / '.config' / 'ignored-config.ini').to_path.freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        dependencies:
          - flake8-bugbear
          - flake8-builtins==1.4.1
          - git+https://github.com/PyCQA/flake8-import-order.git@51e16f33065512afa1a85a20b2c2d3be768f78ea
          - { name: "flake8-docstrings", version: "==1.6.0" }
        target: src/
        config: config/.flake8
        parallel: false
      YAML
    end

    def setup
      begin
        pip_install Array(config_linter[:dependencies] || config_linter[:plugins])
      rescue UserError => exn
        return Results::Failure.new(guid: guid, message: exn.message)
      end

      prepare_config
      yield
    end

    def analyze(changes)
      parallel = [true, nil].include?(config_linter[:parallel])

      capture3!(
        analyzer_bin,
        "--exit-zero",
        "--output-file", report_file,
        "--append-config", DEFAULT_IGNORED_CONFIG_PATH,
        "--jobs", parallel ? "auto" : "1",
        *(config_linter[:config]&.then { |c| ["--config", c] }),
        *Array(config_linter[:target] || DEFAULT_TARGET),
      )
      output = read_report_file

      Results::Success.new(guid: guid, analyzer: analyzer, issues: parse_result(output))
    end

    private

    def prepare_config
      # @see https://flake8.pycqa.org/en/latest/user/configuration.html
      if (current_dir / '.flake8').exist?
        File.delete DEFAULT_CONFIG_PATH
      end

      current_dir.glob('{setup.cfg,tox.ini}').each do |config_file|
        if config_file.exist? && config_file.read.match?(/^\[flake8\]$/m)
          File.delete DEFAULT_CONFIG_PATH
        end
      end
    end

    def parse_result(output)
      issues = []

      # @see https://gitlab.com/pycqa/flake8/-/blob/3.9.0/src/flake8/formatting/default.py#L50
      output.scan(/^(.+):(\d+):(\d+): ([^\s]+) (.+)$/) do |match|
        path, line, column, id, message = match
        issues << Issue.new(
          path: relative_path(path),
          location: Location.new(start_line: line, start_column: column),
          id: id,
          message: message,
        )
      end

      issues
    end
  end
end
