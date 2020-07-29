module Runners::Java : Processor
  def install_jvm_deps: () -> void

  # private
  def jvm_deps_dir: () -> Pathname
  def fetch_deps_via_gradle!: () -> void
  def config_jvm_deps: () -> Array<[String, String, String]>
  def generate_jvm_deps_file: () -> void
end
