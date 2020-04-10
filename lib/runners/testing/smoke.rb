require "minitest"
require "unification_assertion"
require "pp"
require 'parallel'
require "rainbow"

module Runners
  module Testing
    class Smoke
      include Minitest::Assertions
      include UnificationAssertion

      ROOT_DATA_DIR = Pathname('/data')

      attr_reader :argv, :data_container, :data_smoke_path

      Configuration = Struct.new(:ssh_key)

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
        @data_container = SecureRandom.uuid
        @data_smoke_path = ROOT_DATA_DIR / expectations.parent.basename
      end

      def run
        load expectations.to_s

        threads = ENV["JOBS"]&.to_i || Parallel.processor_count * 2
        results = with_data_container do
          Parallel.map(self.class.tests, in_threads: threads) do |name, pattern|
            out = StringIO.new(''.dup)
            result = run_test(name, pattern, out)
            print out.string
            [result, name]
          end
        end

        abort "❌ No smoke tests!" if results.empty?

        passed = results.count { |result,| result == :passed }
        failed = results.count { |result,| result == :failed }
        total = results.count
        summary = "#{passed} passed, #{failed} failed, #{total} total"

        puts "-" * 30
        if failed == 0
          puts "❤️  Smoke tests passed! -- #{summary}"
        else
          puts "❌ Smoke tests failed! -- #{summary}"
          marks = { passed: '✅', failed: '❌' }
          results.each { |result, name| puts "--> #{marks.fetch(result)} #{name}" }
          exit 1
        end
      end

      def run_test(name, pattern, out)
        commandline = command_line(name, self.class.configs.fetch(name))
        out.puts "$ #{commandline}"
        reader = JSONSEQ::Reader.new(io: StringIO.new(`#{commandline}`), decoder: -> (json) { JSON.parse(json, symbolize_names: true) })
        traces = reader.each_object.to_a
        if ENV['SHOW_TRACE']
          traces.each do |trace|
            out.puts colored_pretty_inspect(trace)
          end
        end
        result = traces.find { |object|
          Schema::Result.envelope =~ object
        }

        unify_result(result, pattern, out) ? :passed : :failed
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
        out.puts colored_pretty_inspect(result) unless ok

        ok
      end

      def with_data_container
        system! "docker run --name #{data_container} -v #{ROOT_DATA_DIR} alpine:latest true"
        system! "docker cp #{expectations.parent} #{data_container}:#{ROOT_DATA_DIR}"
        yield
      ensure
        system! "docker rm --force #{data_container}" unless ENV["KEEP_DATA_CONTAINER"]
      end

      def command_line(name, config)
        dir = data_smoke_path / name
        ssh_key = config.ssh_key&.yield_self do |file|
          Dir.mktmpdir do |tmp_dir|
            tmp_ssh_key_path = Pathname(tmp_dir) / 'ssh_key'
            system! "docker cp #{data_container}:#{dir.expand_path / file} #{tmp_ssh_key_path}"
            tmp_ssh_key_path.read
          end
        end
        runners_options = JSON.dump(source: { head: dir.expand_path }, ssh_key: ssh_key)
        commands = %W[docker run --rm --volumes-from #{data_container} --env RUNNERS_OPTIONS='#{runners_options}' #{docker_image} test-guid]
        commands.join(" ")
      end

      def system!(*command_args)
        system(*command_args, exception: true)
      end

      def colored_pretty_inspect(hash)
        hash.pretty_inspect
          .gsub(/(:\w+)=>/, Rainbow('\1').yellow + "=>")
          .gsub(/(nil|false|true)/, Rainbow('\1').cyan)
          .gsub(/("(?:[^\\"]|\\.)*")/, Rainbow('\1').green)
      end

      @tests = {}
      @configs = {}

      # Comma-separated value is also available.
      def self.only?(name)
        value = ENV["ONLY"]
        if value
          value.split(",").map(&:strip).include?(name)
        else
          true
        end
      end

      def self.add_test(name, result, **others)
        return unless only? name

        others[:warnings] ||= []
        others[:ci_config] ||= :_
        others[:version] ||= :_

        @tests[name] = {
          result: result,
          **others,
        }
        @configs[name] = Configuration.new

        yield @configs[name] if block_given?
      end

      def self.tests
        @tests
      end

      def self.configs
        @configs
      end
    end
  end
end
