module Forwardable
  def def_instance_delegators: (Symbol, *Symbol) -> void
  alias def_delegators def_instance_delegators
end
