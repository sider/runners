module Runners
  class Processor::RailsBestPractices < Processor
    include Ruby

    Schema = StrongJSON.new do
      let :runner_config, Schema::BaseConfig.ruby.update_fields { |fields|
        fields.merge!({
                        vendor: boolean?,
                        spec: boolean?,
                        test: boolean?,
                        features: boolean?,
                        exclude: string?,
                        only: string?,
                        config: string?,
                        # DO NOT ADD ANY OPTION under `options`.
                        options: optional(object(
                                            vendor: boolean?,
                                            spec: boolean?,
                                            test: boolean?,
                                            features: boolean?,
                                            exclude: string?,
                                            only: string?,
                                            config: string?,
                                          ))
                      })
      }
    end

    register_config_schema(name: :rails_best_practices, schema: Schema.runner_config)

    OPTIONAL_GEMS = [
      GemInstaller::Spec.new(name: "slim", version: []),
      GemInstaller::Spec.new(name: "haml", version: []),
      GemInstaller::Spec.new(name: "sass", version: []),
      GemInstaller::Spec.new(name: "sassc", version: []),
      # HACK: sassc v1.x does not have `rake` dependency, but fail to install if the `rake` missing
      # https://github.com/sass/sassc-ruby/issues/86
      GemInstaller::Spec.new(name: "rake", version: []),
    ].freeze

    CONSTRAINTS = {
      "rails_best_practices" => [">= 1.19.1", "< 2.0"]
    }.freeze

    def default_gem_specs
      super.tap do |specs|
        # HACK: https://github.com/flyerhzm/code_analyzer/pull/13 is not released yet.
        source = GemInstaller::Source.create(git: {
          repo: "https://github.com/flyerhzm/code_analyzer.git",
          ref: "e31ce438d3858df055bf85334003f29e1bd1673d",
        })
        specs << GemInstaller::Spec.new(name: "code_analyzer", version: [], source: source)
      end
    end

    def setup
      add_warning_if_deprecated_options([:options])

      prepare_config
      install_gems default_gem_specs, optionals: OPTIONAL_GEMS, constraints: CONSTRAINTS do
        yield
      end
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(_changes)
      options = [vendor, spec, test, features, exclude, only, config_option].compact
      run_analyzer(options)
    end

    private

    def vendor
      vendor = config_linter[:vendor]
      vendor = config_linter.dig(:options, :vendor) if vendor.nil?
      if vendor == false
        nil
      else
        "--vendor"
      end
    end

    def spec
      spec = config_linter[:spec] || config_linter.dig(:options, :spec)
      "--spec" if spec
    end

    def test
      test = config_linter[:test] || config_linter.dig(:options, :test)
      "--test" if test
    end

    def features
      features = config_linter[:features] || config_linter.dig(:options, :features)
      "--features" if features
    end

    def exclude
      exclude = config_linter[:exclude] || config_linter.dig(:options, :exclude)
      "--exclude=#{exclude}" if exclude
    end

    def only
      only = config_linter[:only] || config_linter.dig(:options, :only)
      "--only=#{only}" if only
    end

    def config_option
      config = config_linter[:config] || config_linter.dig(:options, :config)
      "--config=#{config}" if config
    end

    def prepare_config
      # NOTE: We expect sider_rails_best_practices.yml to be located in $HOME.
      default_config = Pathname(Dir.home) / 'sider_rails_best_practices.yml'
      path = Pathname("#{current_dir.to_s}/config/rails_best_practices.yml")
      return if path.exist?
      path.parent.mkpath
      FileUtils.cp(default_config, path)
    end

    def run_analyzer(options)
      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        # NOTE: rails_best_practices exit with status code n (issue count)
        #       when some issues are found.
        #       We use `capture3` instead of `capture3!`
        capture3(
          *ruby_analyzer_bin,
          '--without-color',
          '--silent',
          '--output-file', report_file,
          '--format=yaml',
          *options
        )
        # NOTE: rails_best_practices returns top-level YAML array with tags.
        #       We want to just parse a YAML, so we remove YAML tags before passing.
        output = read_report_file
        output.gsub!('- !ruby/object:RailsBestPractices::Core::Error', '-')
        YAML.safe_load(output, symbolize_names: true, filename: report_file).each do |issue|
          # HACK: `line_number` sometimes is not a number.
          line_number = issue.fetch(:line_number)
          start_line = Integer(line_number, exception: false)
          location = if start_line
                       Location.new(start_line: start_line)
                     else
                       file = relative_path(issue.fetch(:filename)).to_path
                       add_warning "Invalid `line_number` is output: #{line_number.inspect}. The line location in `#{file}` is lost.", file: file
                       nil
                     end

          result.add_issue Issue.new(
            path: relative_path(issue.fetch(:filename)),
            location: location,
            id: issue.fetch(:type),
            message: issue.fetch(:message),
            links: Array(issue[:url]),
          )
        end
      end
    end
  end
end
