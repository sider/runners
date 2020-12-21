require "minitest"
require "unification_assertion"
require "parallel"
require "amazing_print"
require "rainbow"
require "openssl"
require "base64"
require "open3"
require "uri"
require "json"
require "jsonseq"
require "strong_json"

require_relative "../../lib/runners/schema/result"

module Runners
  module Testing
    class Smoke
      include Minitest::Assertions

      class TestParams
        attr_reader :name, :pattern, :offline

        def initialize(name:, pattern:, offline:)
          @name = name
          @pattern = pattern
          @offline = offline
        end

        def ==(other)
          self.class == other.class && name == other.name
        end
        alias eql? ==

        def hash
          name.hash
        end
      end

      attr_reader :argv

      def initialize(argv)
        @argv = argv
      end

      def docker_image
        argv[0]
      end

      def entrypoint
        Pathname(argv[0])
      end

      def expectations
        Pathname(argv[1])
      end

      def run
        start = Time.now

        load expectations.to_path

        jobs = ENV["JOBS"] ? Integer(ENV["JOBS"]) : nil
        "Running #{Rainbow(self.class.tests.size.to_s).bright} smoke tests".tap do |msg|
          msg << " with #{Rainbow(jobs.to_s).bright} jobs" if jobs
          puts "#{msg}..."
        end

        marks = { passed: '✅', failed: '❌' }

        task = ->(params) {
          start_per_test = Time.now
          out = StringIO.new(''.dup)
          result = run_test(params, out)
          print out.string
          duration_per_test = (Time.now - start_per_test).round(1)
          puts "#{marks[result]} #{Rainbow(params.name).bright.underline}" + \
               Rainbow(" (#{duration_per_test}s)").darkgray.to_s
          [result, params.name]
        }

        results =
          if jobs == 1
            self.class.tests.map(&task)
          else
            Parallel.map(self.class.tests, in_processes: jobs, &task)
          end

        abort "❌ No smoke tests!" if results.empty?

        passed = results.count { |result,| result == :passed }
        failed = results.count { |result,| result == :failed }
        total = results.count
        duration = (Time.now - start).round(1)

        puts ""
        if failed == 0
          puts Rainbow("#{marks[:passed]} All #{passed} tests passed!").bright.green.to_s + \
               " (#{duration} seconds)"
        else
          puts "#{marks.fetch(:failed)} " + \
               Rainbow("#{passed} passed").green.to_s + ", " + \
               Rainbow("#{failed} failed").red.to_s + ", " + \
               Rainbow("#{total} total").aqua.to_s + \
               " (#{duration} seconds)"
          exit 1
        end
      end

      def run_test(params, out)
        command_output, _ = Dir.mktmpdir do |dir|
          repo_dir, base, head = prepare_git_repository(
            workdir: Pathname(dir).realpath,
            smoke_target: expectations.parent.join(params.name).realpath,
            out: out,
          )
          cmd = command_line(params: params, repo_dir: repo_dir, base: base, head: head)
          sh!(*cmd, out: out, exception: false)
        end

        reader = JSONSEQ::Reader.new(io: StringIO.new(command_output), decoder: -> (json) { JSON.parse(json, symbolize_names: true) })
        traces = reader.each_object.to_a
        if debug_trace?
          traces.each do |trace|
            out.puts colored_pretty_inspect(trace)
          end
        end
        result = traces.find { |object|
          Schema::Result.envelope =~ object
        }

        unify_result(result, params.pattern, out) ? :passed : :failed
      end

      def unify_result(result, pattern, out)
        ok = true

        UnificationAssertion.unify [[result, pattern, ""]] do |a, b, path|
          case
          when (a.is_a?(Regexp) && !b.is_a?(Regexp)) || (!a.is_a?(Regexp) && b.is_a?(Regexp))
            unless a.match?(b)
              ok = false
              out.puts "❌ Pattern matching failed at #{path}:"
              out.puts diff(b, a)
            end
          else
            unless a == b
              ok = false
              out.puts "❌ Pattern matching failed at #{path}:"
              out.puts diff(b, a)
            end
          end
        end
        out.puts colored_pretty_inspect(result, multiline: true) if !ok && debug?

        ok
      end

      def command_line(params:, repo_dir:, base:, head:)
        project_dir = "/project"
        source = {
          head: head,
          base: base,
          git_url: URI.join("file:///", project_dir).to_s,
        }
        runners_options = JSON.dump({ source: source })
        runners_timeout = ENV['RUNNERS_TIMEOUT']
        commands = ["docker", "run"]
        commands << "--rm"
        commands << "--mount" << "type=bind,source=#{repo_dir},target=#{project_dir}"
        commands << "--env" << "RUNNERS_OPTIONS=#{runners_options}"
        commands << "--env" << "RUNNERS_TIMEOUT=#{runners_timeout}" if runners_timeout
        commands << "--env" << "DEBUG=true" if debug?
        commands << "--env" << "EXTRA_CERTIFICATE=#{extra_certificate}" # Test update-ca-certificates(8)
        commands << "--network=none" if params.offline
        commands << docker_image
        commands << params.pattern.dig(:result, :guid)
        commands
      end

      def prepare_git_repository(workdir:, smoke_target:, out:)
        # Create a bare repository
        bare_dir = workdir.join("bare").to_path
        sh! "git", "init", "--bare", bare_dir, out: out

        # Push a smoke test project to the bare directory
        smoke_dir = workdir.join("smoke").to_path
        sh! "git", "clone", "file://#{bare_dir}", smoke_dir, out: out

        Dir.chdir(smoke_dir) do
          sh! "git", "config", "user.name", "Foo", out: out
          sh! "git", "config", "user.email", "foo@example.com", out: out
          sh! "git", "commit", "--allow-empty", "-m", "initial commit", out: out
          base_commit, _ = sh! "git", "rev-parse", "HEAD", out: out

          FileUtils.copy_entry "#{smoke_target}/.", smoke_dir
          sh! "git", "add", ".", out: out
          sh! "git", "commit", "-m", "add all test files", out: out

          sh! "git", "push", out: out
          head_commit, _ = sh! "git", "rev-parse", "HEAD", out: out

          # TODO: Ignored Steep error
          _ = [bare_dir, base_commit.chomp, head_commit.chomp]
        end
      end

      def debug?
        ENV["DEBUG"] == "true"
      end

      def debug_trace?
        ENV["DEBUG"] == "trace"
      end

      def sh!(*command, out:, exception: true)
        if debug?
          out.puts Rainbow("$ ").green.to_s + command.map { |s| s.include?(" ") ? "'#{s}'" : s }.join(" ")
        end

        stdout_str, stderr_str, status = Open3.capture3(*command)
        if debug?
          out.puts Rainbow(stdout_str).darkgray unless stdout_str.empty?
          out.puts Rainbow(stderr_str).darkgray unless stderr_str.empty?
        end
        if exception && !status.success?
          raise "ERROR: #{command} exited with #{status.exitstatus.inspect}"
        end

        [stdout_str, stderr_str]
      end

      def colored_pretty_inspect(obj, multiline: false)
        obj.awesome_inspect(indent: 2, index: false, multiline: multiline)
      end

      def extra_certificate
        key = OpenSSL::PKey::RSA.new(4096)
        extension = OpenSSL::X509::ExtensionFactory.new
        cert = OpenSSL::X509::Certificate.new
        cert.subject = OpenSSL::X509::Name.parse 'CN=test.example.com'
        cert.issuer = OpenSSL::X509::Name.parse 'CN=test.example.com'
        cert.not_before = Time.now
        cert.not_after = Time.now + (60 * 60 * 24)
        cert.version = 2
        cert.serial = 1
        cert.public_key = key.public_key
        extension.subject_certificate = cert
        extension.issuer_certificate = cert
        cert.add_extension(extension.create_extension("basicConstraints", "CA:TRUE", true))
        cert.add_extension(extension.create_extension("subjectKeyIdentifier", "hash", false))
        cert.add_extension(extension.create_extension("authorityKeyIdentifier", "keyid:always", false))
        cert.sign(key, OpenSSL::Digest.new('SHA256'))
        Base64.strict_encode64(cert.to_s)
      end

      @tests = []

      def self.tests
        @tests
      end

      # Comma-separated value is also available.
      def self.only?(name)
        value = ENV["ONLY"]
        if value
          value.split(",").map(&:strip).include?(name)
        else
          true
        end
      end

      def self.add_test(name, **pattern)
        add_test_helper TestParams.new(name: name, pattern: build_pattern(**pattern), offline: false)
      end

      def self.add_offline_test(name, **pattern)
        add_test_helper TestParams.new(name: name, pattern: build_pattern(**pattern), offline: true)
      end

      def self.add_test_helper(test)
        return unless only? test.name

        if tests.include? test
          raise ArgumentError, "Smoke test #{test.name.inspect} is duplicate"
        else
          tests << test
        end
      end

      def self.build_pattern(type:,
                             guid: "test-guid",
                             timestamp: :_,
                             issues: nil,
                             message: nil,
                             analyzer: nil,
                             class: nil,
                             backtrace: nil,
                             inspect: nil,
                             warnings: [],
                             ci_config: :_,
                             config_file: :_,
                             version: :_)
        {
          result: {
            type: type,
            guid: guid,
            timestamp: timestamp,
            issue_count: issues == :_ ? :_ : issues&.size,
            issues: issues,
            message: message,
            analyzer: analyzer,
            class: binding.local_variable_get(:class),
            backtrace: backtrace,
            inspect: inspect,
          }.compact,
          warnings: warnings,
          ci_config: ci_config,
          config_file: config_file,
          version: version,
        }
      end
    end
  end
end
