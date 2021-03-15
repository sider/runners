module Runners
  module Ruby
    class GemInstaller
      class InstallationFailure < InstallGemsFailure; end

      attr_reader :gem_home, :specs, :trace_writer, :shell, :constraints, :config_path_name, :use_local

      def initialize(shell:, home:, config_path_name:, specs:, constraints:, trace_writer:, use_local:)
        @gem_home = home
        @specs = specs
        @shell = shell
        @config_path_name = config_path_name
        @constraints = constraints
        @trace_writer = trace_writer
        @use_local = use_local
      end

      def gemfile_path
        gem_home / "Gemfile"
      end

      def lockfile_path
        gemfile_path.sub_ext(".lock")
      end

      def install!(&block)
        gemfile_path.write(gemfile_content)

        trace_writer.message "Installing gems..."

        Bundler.with_unbundled_env do
          shell.chdir gem_home do
            install_args = use_local ? %w[--local] : []
            shell.capture3!("bundle", "install", *install_args)
            shell.capture3!("bundle", "list")
          rescue Shell::ExecError
            raise InstallationFailure.new(<<~MESSAGE.strip)
              Failed to install gems according to `#{config_path_name}` and `Gemfile.lock`.
              You can select the version of gems you want to install via `#{config_path_name}`.
              See https://help.sider.review/getting-started/custom-configuration#linteranalyzer_idgems
            MESSAGE
          end

          shell.push_env_hash({ "BUNDLE_GEMFILE" => gemfile_path.to_s }, &block)
        end
      end

      # @see https://bundler.io/man/gemfile.5.html
      def gemfile_content
        trace_writer.message "Generating optimized Gemfile..."

        # @type var lines: Array[String]
        lines = []
        lines << %{source "#{Source.default.uri}"}
        lines << ""

        specs.sort_by(&:name).each do |spec|
          lines << gem(spec, gem_constraints(spec))
        end

        (lines.join("\n") + "\n").tap do |content|
          trace_writer.message <<~MSG
            ### Auto-generated Gemfile ###
            #{content.chomp}
          MSG
        end
      end

      private

      def gem(spec, constraint)
        s = %{gem "#{spec.name}"}

        source = spec.source

        if !constraint.none? && !source.git?
          s << ", "
          s << constraint.to_s.split(",").map { |c| %{"#{c.strip}"} }.uniq.join(", ")
        end

        if source.git?
          s << %{, git: "#{source.repo}"}
          s << %{, ref: "#{source.ref}"} if source.ref
          s << %{, branch: "#{source.branch}"} if source.branch
          s << %{, tag: "#{source.tag}"} if source.tag
        elsif !source.default?
          s << %{, source: "#{source.uri}"}
        end

        s
      end

      def gem_constraints(spec)
        req = spec.requirement.dup

        # NOTE: Gems with Git source do not need constraints.
        req.concat(constraints[spec.name].to_s.split(",")) unless spec.source.git?

        req
      end
    end
  end
end
