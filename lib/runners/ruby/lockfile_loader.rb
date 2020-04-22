module Runners
  module Ruby
    class LockfileLoader
      include Tmpdir

      class InvalidGemfileLock < InstallGemsFailure; end

      attr_reader :root_dir
      attr_reader :shell

      def initialize(root_dir:, shell:)
        @root_dir = root_dir
        @shell = shell
      end

      def ensure_lockfile
        lockfile_content =
          case
          when gemfile_path.file? && gemfile_lock_path.file?
            shell.trace_writer.message "Gemfile and Gemfile.lock detected"
            gemfile_lock_path.read
          when gemfile_path.file?
            mktmpdir do |dir|
              generate_lockfile(dir / "Gemfile.lock")
            end
          end

        begin
          yield Lockfile.new(lockfile_content)
        rescue Bundler::LockfileError
          raise InvalidGemfileLock.new(<<~MESSAGE)
            An error was found in the Gemfile.lock. Please fix the Gemfile.lock according to the above error message.
          MESSAGE
        end
      end

      private

      def gemfile_path
        @gemfile_path ||= (root_dir / "Gemfile")
      end

      def gemfile_lock_path
        @gemfile_lock_path ||= (root_dir / "Gemfile.lock")
      end

      def generate_lockfile(lockfile_path)
        shell.trace_writer.message "By using detected Gemfile, generating Gemfile.lock..."

        Bundler.with_unbundled_env do
          shell.push_env_hash({ "BUNDLE_GEMFILE" => gemfile_path.to_s }) do
            shell.capture3! "bundle", "lock", "--lockfile", lockfile_path.to_s
            return lockfile_path.read.tap do |content|
              shell.trace_writer.message content
            end
          rescue Shell::ExecError
            shell.trace_writer.error <<~MESSAGE
              An error was found in your Gemfile but Sider continues the analysis by ignoring your dependencies.
              If you want to make Sider aware of your dependencies, please fix the Gemfile according to the above error message, or commit your Gemfile.lock.
            MESSAGE
          end
        end

        nil
      end
    end
  end
end
