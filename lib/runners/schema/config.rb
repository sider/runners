module Runners
  module Schema
    module ConfigTypes
      include StrongJSON::Types

      def one_or_more_strings?
        enum?(string, array(string))
      end

      def target
        one_or_more_strings?
      end

      def dependency(**fields)
        object(name: string, version: string, **fields)
      end

      def base(**fields)
        object(root_dir: string?, **fields)
      end

      def ruby(**fields)
        git = enum(
          object(repo: string, branch: string),
          object(repo: string, tag: string),
          object(repo: string, ref: string),
        )
        dependencies = array?(enum(
          string,
          dependency(source: string?),
          object(name: string, git: git),
        ))

        base(
          dependencies: dependencies,
          gems: dependencies, # alias
          **fields,
        )
      end

      def cplusplus(**fields)
        base(
          dependencies: array?(enum(string, dependency)),
          apt: one_or_more_strings?, # deprecated
          'include-path': one_or_more_strings?,
          **fields,
        )
      end

      def npm(**fields)
        base(
          dependencies: array?(enum(string, dependency)),
          npm_install: enum?(boolean, literal('development'), literal('production')),
          **fields,
        )
      end

      def java(**fields)
        base(
          dependencies: array?(enum(string, dependency)),
          jvm_deps: array?(array(enum(string, number))), # deprecated
          **fields,
        )
      end
    end

    Config = _ = StrongJSON.new do
      # @type self: ConfigClass

      @linter = {}

      let :payload, object(
        linter: object?(@linter),
        ignore: enum?(string, array(string)),
        branches: object?(exclude: enum?(string, array(string))),
      )

      def self.register(name:, schema:)
        if @linter.include? name
          raise ArgumentError, "#{name.inspect} is already registered"
        end
        @linter[name] = optional(schema)
        payload.fields[:linter] = object?(@linter)
      end
    end
  end
end
