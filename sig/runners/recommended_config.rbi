module Runners::RecommendedConfig : Processor
  def deploy_recommended_config_file: (activate: bool, release_date: String:, config_filename: String, skips: any) -> void

  # private
  def notify_release: (config_filename: String, release_date: String) -> void
  def deploy_file: (config_filename: String, skips: any) -> void
end
