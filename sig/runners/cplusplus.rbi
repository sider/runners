module Runners::CPlusPlus : Processor
  def option_include_path: () -> Array<String>

  # private
  def find_paths_containing_headers: () -> Array<String>
end

Runners::CPlusPlus::GLOB_HEADERS: String
