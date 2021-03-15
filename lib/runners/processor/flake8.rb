module Runners
  class Processor::Flake8 < Processor
    include Python

    Schema = _ = StrongJSON.new do
      # @type self: SchemaClass

      let :runner_config, Schema::BaseConfig.base.update_fields { |fields|
        fields.merge!({
          target: enum?(string, array(string)),
          config: string?,
          plugins: enum?(string, array(string)),
          parallel: boolean?,
        })
      }
    end

    register_config_schema(name: :flake8, schema: Schema.runner_config)

    # Output example:
    #
    # E999:::app1/views.py:::6:::12:::IndentationError: unexpected indent
    #
    # `:::` is a separater
    #
    OUTPUT_FORMAT = '%(code)s:::%(path)s:::%(row)d:::%(col)d:::%(text)s'.freeze
    OUTPUT_PATTERN = /^([^:]+):::([^:]+):::(\d+):::(\d+):::(.+)$/.freeze

    DEFAULT_TARGET = ".".freeze
    DEFAULT_CONFIG_PATH = (Pathname(Dir.home) / '.config' / 'flake8').to_path.freeze
    DEFAULT_IGNORED_CONFIG_PATH = (Pathname(Dir.home) / '.config' / 'ignored-config.ini').to_path.freeze

    def self.config_example
      <<~'YAML'
        root_dir: project/
        target: src/
        config: config/.flake8
        plugins:
          - flake8-bandit
          - flake8-builtins==1.4.1
          - flake8-docstrings>=1.4.0
          - git+https://github.com/PyCQA/flake8-import-order.git@51e16f33065512afa1a85a20b2c2d3be768f78ea
        parallel: false
      YAML
    end

    def setup
      prepare_config
      prepare_plugins
      yield
    end

    def analyze(changes)
      parallel = [true, nil].include?(config_linter[:parallel])

      capture3!(
        analyzer_bin,
        "--exit-zero",
        "--output-file", report_file,
        "--format", OUTPUT_FORMAT,
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

    def prepare_plugins
      pip_install(*Array(config_linter[:plugins]))
    end

    def parse_result(output)
      issues = []
      output.scan(OUTPUT_PATTERN) do |match|
        id, path, line, column, message = match
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
