require "minitest"
require "unification_assertion"
require "pp"
require 'parallel'
require "amazing_print"

module Runners
  module Testing
    class Smoke
      include Minitest::Assertions
      include UnificationAssertion
      include Tmpdir

      PROJECT_PATH = "/project".freeze

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
        puts "Running smoke tests..."
        load expectations.to_s

        results = Parallel.map(self.class.tests, in_processes: ENV["JOBS"]&.to_i) do |params|
          out = StringIO.new(''.dup)
          result = run_test(params, out)
          print out.string
          [result, params.name]
        end

        abort "❌ No smoke tests!" if results.empty?

        passed = results.count { |result,| result == :passed }
        failed = results.count { |result,| result == :failed }
        total = results.count
        summary = "#{passed} passed, #{failed} failed, #{total} total"

        puts
        if failed == 0
          puts "❤️  Smoke tests passed! -- #{summary}"
        else
          puts "❌ Smoke tests failed! -- #{summary}"
          marks = { passed: '✅', failed: '❌' }
          results.each { |result, name| puts "--> #{marks.fetch(result)} #{name}" }
          exit 1
        end
      end

      def run_test(params, out)
        cmd = command_line(params)
        out.puts
        out.puts "$ #{cmd}"
        reader = JSONSEQ::Reader.new(io: StringIO.new(`#{cmd}`), decoder: -> (json) { JSON.parse(json, symbolize_names: true) })
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
        out.puts colored_pretty_inspect(result) unless ok

        ok
      end

      def command_line(params)
        smoke_target = (expectations.parent / params.name).realpath
        runners_options = JSON.dump({ source: { head: PROJECT_PATH } })
        commands = %w[docker run --rm]
        commands << "--mount" << "type=bind,source=#{smoke_target},target=#{PROJECT_PATH}"
        commands << "--env" << "RUNNERS_OPTIONS='#{runners_options}'"
        commands << "--network=none" if params.offline
        commands << docker_image
        commands << params.pattern.dig(:result, :guid)
        commands.join(" ")
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
