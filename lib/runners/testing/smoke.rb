require "minitest"
require "unification_assertion"
require "pp"
require 'parallel'
require "amazing_print"
require "rainbow"

module Runners
  module Testing
    class Smoke
      include Minitest::Assertions
      include UnificationAssertion
      include Tmpdir

      TestParams = Struct.new(:name, :pattern, :offline, keyword_init: true)

      attr_reader :argv

      def docker_image
        argv[0]
      end

      def entrypoint
        Pathname(argv[0])
      end

      def expectations
        Pathname(argv[1])
      end

      def initialize(argv)
        @argv = argv
      end

      def run
        start = Time.now

        load expectations.to_s

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
        if ENV['SHOW_TRACE']
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
        unify [[result, pattern, ""]] do |a, b, path|
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
        out.puts colored_pretty_inspect(result) if !ok && debug?

        ok
      end

      def command_line(params:, repo_dir:, base:, head:)
        project_dir = "/project"
        source = {
          head: head,
          base: base,
          git_http_url: "file://#{project_dir}",
          owner: "smoke",
          repo: params.name,
        }
        runners_options = JSON.dump({ source: source })
        commands = ["docker", "run"]
        commands << "--rm"
        commands << "--mount" << "type=bind,source=#{repo_dir},target=#{project_dir}"
        commands << "--env" << "RUNNERS_OPTIONS=#{runners_options}"
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

          [bare_dir, base_commit.chomp, head_commit.chomp]
        end
      end

      def debug?
        ENV["DEBUG"]
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

      def colored_pretty_inspect(hash)
        hash.awesome_inspect(indent: 2, index: false)
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

      def self.add_test(name, type:, guid: "test-guid", timestamp: :_,
                        issues: nil, message: nil, analyzer: nil,
                        class: nil, backtrace: nil, inspect: nil,
                        warnings: [], ci_config: :_, version: :_)
        return unless only? name

        check_duplicate name

        pattern = build_pattern(type: type, guid: guid, timestamp: timestamp,
          issues: issues, message: message, analyzer: analyzer,
          class: binding.local_variable_get(:class), backtrace: backtrace, inspect: inspect,
          warnings: warnings, ci_config: ci_config, version: version
        )

        tests << TestParams.new(name: name, pattern: pattern, offline: false)
      end

      def self.add_offline_test(name, type:, guid: "test-guid", timestamp: :_,
                                issues: nil, message: nil, analyzer: nil,
                                class: nil, backtrace: nil, inspect: nil,
                                warnings: [], ci_config: :_, version: :_)
        return unless only? name

        check_duplicate name

        pattern = build_pattern(
          type: type, guid: guid, timestamp: timestamp,
          issues: issues, message: message, analyzer: analyzer,
          class: binding.local_variable_get(:class), backtrace: backtrace, inspect: inspect,
          warnings: warnings, ci_config: ci_config, version: version
        )

        tests << TestParams.new(name: name, pattern: pattern, offline: true)
      end

      def self.check_duplicate(name)
        if tests.find { |t| t.name === name }
          raise ArgumentError, "Smoke test #{name.inspect} is duplicate"
        end
      end

      def self.build_pattern(**fields)
        optional = {
          issues: fields.fetch(:issues),
          message: fields.fetch(:message),
          analyzer: fields.fetch(:analyzer),
          class: fields.fetch(:class),
          backtrace: fields.fetch(:backtrace),
          inspect: fields.fetch(:inspect),
        }.compact

        {
          result: { guid: fields.fetch(:guid), timestamp: fields.fetch(:timestamp), type: fields.fetch(:type), **optional },
          warnings: fields.fetch(:warnings),
          ci_config: fields.fetch(:ci_config),
          version: fields.fetch(:version),
        }
      end
    end
  end
end
