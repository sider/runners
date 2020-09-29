module Runners::RecommendedConfig : Processor
  def warn_recommended_config_file_release: (config_filename: String, release_date: String) -> Any
  def prepare_config_file: (config_filename: String) -> Any
end
