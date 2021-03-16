module Runners
  module Ruby
    class LockfileLoader
      class Lockfile
        def initialize(lockfile_content)
          @specs = lockfile_content ? LockfileParser.parse(lockfile_content).specs : []
        end

        def empty?
          specs.empty?
        end

        def spec_exists?(spec)
          !!find_spec(spec)
        end

        def locked_version(spec)
          find_spec(spec)&.version
        end

        def locked_version!(spec)
          locked_version(spec) or raise ArgumentError.new("lockfile=#{inspect}, spec=#{spec.inspect}")
        end

        def satisfied_by?(spec, constraints)
          found = find_spec(spec)
          if found
            Gem::Requirement.create(constraints[found.name]).satisfied_by?(found.version)
          else
            raise "Spec not found: #{spec}, lockfile=#{specs.inspect}"
          end
        end

        private

        attr_reader :specs

        def find_spec(spec)
          spec_name = spec.is_a?(String) ? spec : spec.name
          specs.find { |s| s.name == spec_name }
        end
      end
    end
  end
end
