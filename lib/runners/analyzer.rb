module Runners
  class Analyzer
    attr_reader :name
    attr_reader :version

    def initialize(name:, version:)
      @name = name
      @version = version
    end

    def valid?
      name.is_a?(String) && version.is_a?(String)
    end

    def as_json
      { name: name, version: version }
    end

    def ==(other)
      other.instance_of?(self.class) && name == other.name && version == other.version
    end
  end
end
