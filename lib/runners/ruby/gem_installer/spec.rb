module Runners
  module Ruby
    class GemInstaller
      class Spec
        attr_reader :name, :requirement, :source

        def initialize(name, requirement: [], source: Source.default)
          @name = name
          @requirement = requirement.is_a?(Gem::Requirement) ? requirement : Gem::Requirement.create(*requirement)
          @source = source
        end

        def ==(other)
          self.class == other.class && name == other.name && requirement == other.requirement && source == other.source
        end
        alias eql? ==

        def hash
          name.hash ^ requirement.hash ^ source.hash
        end

        def override_by_lockfile(lockfile)
          locked_version = lockfile.locked_version(self)
          new_version = locked_version ? [locked_version] : requirement
          self.class.new(name, requirement: new_version, source: source)
        end
      end
    end
  end
end
