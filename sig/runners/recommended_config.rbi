module Runners::RecommendedConfig : Processor
  def deploy_recommended_config_file: (bool, String, String, ?any) -> void

  # private
  def notify_release: (String, String) -> void
  def deploy_file: (String, any) -> void
end
