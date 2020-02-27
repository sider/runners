module Runners
  module Schema
    BaseConfig = _ = StrongJSON.new do
      # @type self: Types::BaseConfig

      let :base, object(
        root_dir: string?,
      )

      let :git, enum(
        object(repo: string, branch: string),
        object(repo: string, tag: string),
        object(repo: string, ref: string),
      )

      let :ruby, (base.update_fields { |fields|
        fields.merge!(
          gems: array?(
            enum(
              string,
              object(name: string, version: string, source: string?),
              object(name: string, git: git),
            )
          )
        )
      })

      let :npm_install, enum(boolean, literal('development'), literal('production'))

      let :npm, (base.update_fields { |fields|
        fields.merge!(npm_install: optional(npm_install))
      })
    end

    Config = _ = StrongJSON.new do
      # @type self: Types::Config

      @linter = {}

      let :payload, object(
        linter: optional(object(@linter)),
        ignore: enum?(string, array(string)),
        branches: object?(exclude: enum?(string, array(string))),
      )

      def register(name:, schema:)
        if @linter.include? name
          raise ArgumentError, "#{name.inspect} is already registered"
        end
        @linter[name] = optional(schema)
        payload.fields[:linter] = optional(object(@linter))
      end
    end
  end
end
