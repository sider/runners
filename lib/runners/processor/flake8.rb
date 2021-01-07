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
    IGNORED_CONFIG_PATH = (Pathname(Dir.home) / '.config/ignored-config.ini').to_path.freeze

    def setup
      prepare_config
      prepare_plugins
      yield
    end

    def analyze(changes)
      capture3!(
        analyzer_bin,
        "--exit-zero",
        "--output-file", report_file,
        "--format", OUTPUT_FORMAT,
        "--append-config", IGNORED_CONFIG_PATH,
        *(config_linter[:config]&.then { |c| ["--config", c] }),
        *Array(config_linter[:target] || DEFAULT_TARGET),
      )
      output = read_report_file

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        next if output.empty?
        parse_result(output) { |issue| result.add_issue(issue) }
      end
    end

    private

    def prepare_config
      default_config = (Pathname(Dir.home) / '.config/flake8').realpath
      return default_config.delete if (current_dir / '.flake8').exist?
      configs = %w[setup.cfg tox.ini].select do |v|
        path = (current_dir + v)
        path.exist? && path.read.match(/^\[flake8\]$/m)
      end
      return default_config.delete unless configs.empty?
    end

    def prepare_plugins
      pip_install(*Array(config_linter[:plugins]))
    end

    def parse_result(output)
      output.scan(OUTPUT_PATTERN) do |match|
        id, path, line, column, message = match
        yield Issue.new(
          path: relative_path(path),
          location: Location.new(start_line: line, start_column: column),
          id: id,
          message: message,
        )
      end
    end
  end
end
