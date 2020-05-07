module Runners
  module Ruby
    class GemInstaller
      class InstallationFailure < InstallGemsFailure; end

      DEFAULT_SOURCE = "https://rubygems.org"

      attr_reader :gem_home, :specs, :trace_writer, :shell, :constraints, :config_path_name

      def initialize(shell:, home:, config_path_name:, specs:, constraints:, trace_writer:)
        @gem_home = home
        @specs = specs
        @shell = shell
        @config_path_name = config_path_name
        @constraints = constraints
        @trace_writer = trace_writer
      end

      def gemfile_path
        gem_home + "Gemfile"
      end

      def lockfile_path
        gemfile_path.sub_ext(".lock")
      end

      def install!
        gemfile_path.write(gemfile_content)

        trace_writer.header "Installing gems..."

        Bundler.with_unbundled_env do
          shell.push_dir gem_home do
            shell.capture3!("bundle", "install")
            shell.capture3!("bundle", "list")
          rescue Shell::ExecError
            raise InstallationFailure.new(<<~MESSAGE.strip)
              Failed to install gems. Sider automatically installs gems according to `#{config_path_name}` and `Gemfile.lock`.
              You can select the version of gems you want to install via `#{config_path_name}`.
              See https://help.sider.review/getting-started/custom-configuration#gems-option
            MESSAGE
          end

          versions = LockfileParser.parse(lockfile_path.read).specs.map do |spec|
            [spec.name, spec.version.version]
          end.to_h

          shell.push_env_hash({ "BUNDLE_GEMFILE" => gemfile_path.to_s }) do
            yield versions
          end
        end
      end

      def gemfile_content
        trace_writer.header "Generating optimized Gemfile..."

        # @type var lines: Array<String>
        lines = ["source #{DEFAULT_SOURCE.inspect}", ""]

        group_specs.each do |source, specs|
          if source.default?
            specs.each do |spec|
              lines << gem(spec, gem_constraints(spec, source))
            end
          else
            lines << "" if !lines.last&.empty?
            lines << "#{source} do"
            specs.each do |spec|
              lines << "  #{gem(spec, gem_constraints(spec, source))}"
            end
            lines << "end"
          end
        end

        (lines.join("\n") + "\n").tap do |res|
          trace_writer.message res
        end
      end

      private

      def group_specs
        specs
          .group_by(&:source)
          .sort_by do |source,|
            case
            when source.default? then 0
            when source.rubygems? then 1
            else 2
            end
          end
      end

      def gem(spec, constraints)
        declaration = "gem #{spec.name.inspect}"
        constraint = constraints.map(&:inspect).join(", ")
        (constraint.empty? ? declaration : "#{declaration}, #{constraint}")
      end

      def gem_constraints(spec, source)
        # NOTE: Gems with Git source do not need constraints.
        return [] if source.git?

        (spec.version + (constraints[spec.name] || [])).uniq
      end
    end
  end
end
