module Runners
  class Issue
    attr_reader :path
    attr_reader :location
    attr_reader :id
    attr_reader :message
    attr_reader :links
    attr_reader :object
    attr_reader :git_blame_info

    def initialize(path:, location:, id:, message:, links: [], object: nil, schema: nil)
      path.instance_of?(Pathname) or
        raise ArgumentError, "#{path.inspect} must be a #{Pathname}"

      (id && !id.empty?) or
        raise ArgumentError, "#{id.inspect} must be required"

      (message && !message.empty?) or
        raise ArgumentError, "#{message.inspect} must be required"

      schema.coerce(object) if object && schema

      @path = path
      @location = location
      @id = id
      @message = message
      @links = links
      @object = object
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      other.class == self.class &&
        other.path == path &&
        other.location == location &&
        other.id == id &&
        other.message == message &&
        other.links == links &&
        other.object == object
    end

    def hash
      path.hash ^ location.hash ^ id.hash ^ message.hash ^ links.hash ^ object.hash ^ git_blame_info.hash
    end

    def as_json
      Schema::Issue.issue.coerce({
        path: path.to_s,
        location: location&.as_json,
        id: id,
        message: message,
        links: links,
        object: object,
        git_blame_info: git_blame_info&.to_h,
      })
    end

    def add_git_blame_info(workspace)
      loc = location # NOTE: It's required to pass typecheck
      @git_blame_info = if loc
                          workspace.range_git_blame_info(path.to_s, loc.start_line, loc.start_line).first
                        else
                          nil
                        end
    end
  end
end
