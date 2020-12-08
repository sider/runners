module Runners
  class Metric
    attr_reader :path
    attr_reader :type
    attr_reader :object

    def initialize(path:, type:, object: nil, schema: nil)
      path.instance_of?(Pathname) or
        raise ArgumentError, "`path` must be a #{Pathname}: #{path.inspect}"

      schema.coerce(object) if object && schema

      @path = path
      @type = type
      @object = object
    end

    def ==(other)
      other.class == self.class &&
        other.type == type &&
        other.object == object &&
        other.git_blame_info == git_blame_info
    end
    alias eql? ==

    def hash
      path.hash ^ type.hash ^ object.hash
    end

    def as_json
      Schema::Metric.metric.coerce({
        path: path.to_path,
        type: type,
        object: object,
      })
    end
  end
end
