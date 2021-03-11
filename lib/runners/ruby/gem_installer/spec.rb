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
      end
    end
  end
end
