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
        raise ArgumentError, "`path` must be a #{Pathname}: #{path.inspect}"

      (message && !message.empty?) or
        raise ArgumentError, "`message` must be required: #{message.inspect}"

      schema.coerce(object) if object && schema

      @path = path
      @location = location
      @missing_id = id.to_s.empty?
      # @type var _: String
      @id = _ = missing_id? ? Digest::SHA1.hexdigest(message) : id
      @message = message
      @links = links
      @object = object
    end

    def missing_id?
      @missing_id
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
    alias eql? ==

    def hash
      path.hash ^ location.hash ^ id.hash ^ message.hash ^ links.hash ^ object.hash ^ git_blame_info.hash
    end

    def as_json
      Schema::Issue.issue.coerce({
        path: path.to_path,
        location: location&.as_json,
        id: id,
        message: message,
        links: links,
        object: object,
        git_blame_info: git_blame_info&.to_h,
      })
    end

    def add_git_blame_info(workspace)
      start_line = location&.start_line
      @git_blame_info = if start_line
                          workspace.range_git_blame_info(path.to_path, start_line, start_line).first
                        else
                          nil
                        end
    end
  end
end
