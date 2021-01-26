module Runners
  module Ruby
    class GemInstaller
      class Spec
        attr_reader :name, :version, :source

        alias versions version

        def initialize(name:, version:, source: Source.default)
          @name = name
          @version = version
          @source = source
        end

        def ==(other)
          self.class == other.class && name == other.name && version == other.version && source == other.source
        end
        alias eql? ==

        def hash
          name.hash ^ version.hash ^ source.hash
        end

        def override_by_lockfile(lockfile)
          locked_version = lockfile.locked_version(self)
          new_version = locked_version ? [locked_version] : version
          Spec.new(name: name, version: new_version, source: source)
        end

        def self.from_gems(gems_items)
          gems_items.map do |item|
            # TODO: Ignored Steep error
            gem = _ =
              case item
              when Hash
                item
              when String
                { name: item.to_s, version: nil, source: nil, git: nil }
              end

            self.new(
              name: gem.fetch(:name),
              version: Array(gem[:version]),
              source: Source.create(gem),
            )
          end
        end

        def self.merge(default_gems, user_gems)
          specs = []

          default_gems_hash = default_gems.each.with_object({}) do |spec, hash|
            hash[spec.name] = spec
          end
          user_gems_hash = user_gems.each.with_object({}) do |spec, hash|
            hash[spec.name] = spec
          end

          default_gems_hash.each do |_, spec|
            if (user_spec = user_gems_hash[spec.name])
              specs << GemInstaller::Spec.new(
                name: spec.name,
                version: user_spec.version,
                source: user_spec.source
              )
            else
              specs << spec
            end
          end

          user_gems_hash.each do |_, spec|
            unless default_gems_hash.key?(spec.name)
              specs << spec
            end
          end

          specs
        end
      end
    end
  end
end
