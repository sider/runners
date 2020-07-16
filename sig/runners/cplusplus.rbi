module Runners::CPlusPlus : Processor
  def config_include_path: () -> Array<String>

  # private
  def find_paths_containing_headers: () -> Array<String>
end

Runners::CPlusPlus::GLOB_HEADERS: String
