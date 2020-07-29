class Runners::IO
  attr_reader ios: Array<any>

  def initialize: (*any) -> any
  def write: (*_ToS) -> void
  def flush: () -> void
  def flush!: () -> void
end
