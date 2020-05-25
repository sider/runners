class Runners::SensitiveFilter
  @options: Options

  def initialize: (options: Options) -> void
  def sensitives: () -> Array<String>
  def mask: (String) -> String
end

Runners::SensitiveFilter::FILTERED: String
