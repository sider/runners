extension Class (ActiveSupport)
  def subclasses: -> Array<Class>
end

extension Object (ActiveSupport)
  def presence: -> self?
  def present?: -> bool
end

extension Hash (ActiveSupport)
  def symbolize_keys: -> self
end
