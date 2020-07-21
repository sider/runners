module Runners::CPlusPlus : Processor
  def config_include_path: () -> Array<String>
  def cpp_file?: (Pathname) -> bool
  def install_apt_packages: () -> any

  # private
  def find_paths_containing_headers: () -> Array<String>
end

Runners::CPlusPlus::CPP_SOURCES_GLOB: String
Runners::CPlusPlus::CPP_HEADERS_GLOB: String
