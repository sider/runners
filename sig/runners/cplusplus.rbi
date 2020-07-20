module Runners::CPlusPlus : Processor
  def config_include_path: () -> Array<String>
  def is_source_file?: (Pathname) -> bool

  # private
  def find_paths_containing_headers: () -> Array<String>
end

Runners::CPlusPlus::GLOB_SOURCES: String
Runners::CPlusPlus::GLOB_HEADERS: String
