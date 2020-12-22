module Runners
  module Ruby
    class LockfileLoader
      class Lockfile
        attr_reader :specs

        def initialize(lockfile_content)
          @specs = if lockfile_content
                     LockfileParser.parse(lockfile_content).specs.map do |spec|
                       GemInstaller::Spec.new(name: spec.name, version: Array(spec.version.version))
                     end
                   else
                     []
                   end
        end

        def spec_exists?(spec)
          !!find_spec(spec)
        end

        def locked_version(spec)
          found = find_spec(spec)
          found ? found.version.first : nil
        end

        def locked_version!(spec)
          locked_version(spec) or
            raise ArgumentError.new("lockfile=#{inspect}, spec=#{spec.inspect}")
        end

        def satisfied_by?(spec, constraints)
          found = find_spec(spec)
          version, = found&.version
          if found && version
            Gem::Requirement.create(constraints[found.name]).satisfied_by?(Gem::Version.create(version))
          else
            raise "Spec not found: #{spec}, lockfile=#{specs.inspect}"
          end
        end

        private

        def find_spec(spec)
          spec_name = spec.is_a?(String) ? spec : spec.name
          specs.find { |s| s.name == spec_name }
        end
      end
    end
  end
end
