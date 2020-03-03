class Runners::Analyzers
  def name: (Symbol | String) -> String
  def github: (Symbol | String) -> String
  def doc: (Symbol | String) -> String
  def deprecated?: (Symbol | String) -> bool
  def content: () -> Hash<Symbol, Hash<Symbol, any>>
  def analyzer: (Symbol | String) -> Hash<Symbol, any>
end
