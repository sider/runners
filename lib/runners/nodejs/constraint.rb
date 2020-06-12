module Runners
  module Nodejs
    class Constraint
      def initialize(version, *versions)
        @versions = [version, *versions].map { |v| v.delete(" ") }
        @requirements = @versions.map { |ver| Gem::Requirement.create(ver) }
      end

      def to_s
        @versions.join(" ")
      end

      def satisfied_by?(dependency)
        version = Gem::Version.create(dependency.version)
        @requirements.all? { |requirement| requirement.satisfied_by? version }
      end

      def unsatisfied_by?(dependency)
        !satisfied_by?(dependency)
      end
    end
  end
end
