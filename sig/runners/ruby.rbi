module Runners::Ruby : Processor
  # Install given gems and setup environment variables, and yield the block
  def install_gems: <'x> (Array<GemInstaller::Spec>, ?optionals: Array<GemInstaller::Spec>, constraints: Hash<String, Array<String>>) { (Hash<String, String>) -> 'x } -> 'x
  def default_specs: (Array<GemInstaller::Spec>, Hash<String, Array<String>>, LockfileLoader::Lockfile) -> Array<GemInstaller::Spec>
  def optional_specs: (Array<GemInstaller::Spec>, LockfileLoader::Lockfile) -> Array<GemInstaller::Spec>
  def user_specs: (Array<GemInstaller::Spec>, LockfileLoader::Lockfile) -> Array<GemInstaller::Spec>
  def ruby_analyzer_bin: -> Array<String>
  def installed_gem_versions: (String, *String, ?exception: bool) -> Hash<String, Array<String>>
  def default_gems: (?String, *String) -> Array<GemInstaller::Spec>
end

type Runners::Ruby::gems_item = {
  name: String,
  version: String?,
  source: String?,
  git: git_source?,
}

type Runners::Ruby::git_source = {
  repo: String,
  ref: String?,
  branch: String?,
  tag: String?,
}

Runners::Ruby::GemInstaller::DEFAULT_SOURCE: String

class Runners::Ruby::GemInstaller
  attr_reader trace_writer: TraceWriter
  attr_reader gem_home: Pathname
  attr_reader specs: Array<Spec>
  attr_reader shell: Shell
  attr_reader constraints: Hash<String, Array<String>>

  def initialize: (shell: Shell,
                   home: Pathname,
                   config_path_name: String,
                   specs: Array<Spec>,
                   constraints: Hash<String, Array<String>>,
                   trace_writer: TraceWriter) -> void
  def install!: <'x> { (Hash<String, String>) -> 'x } -> 'x
  def gemfile_path: -> Pathname
  def gemfile_content: -> String
  def group_specs: -> Array<[any, Array<Spec>]>
  def gem: (Spec, Array<String>) -> String
  def gem_constraints: (Spec, source_type) -> Array<String>
end

class Runners::Ruby::GemInstaller::Spec
  attr_reader name: String
  attr_reader version: Array<String>
  attr_reader source: source_type

  alias versions version

  def initialize: (name: String, version: Array<String>, ?source: source_type) -> any
  def override_by_lockfile: (LockfileLoader::Lockfile) -> self

  def self.from_gems: (Array<gems_item | String>) -> Array<Spec>
  def self.merge: (Array<Spec>, Array<Spec>) -> Array<Spec>
end

type Runners::Ruby::GemInstaller::source_type = Runners::Ruby::GemInstaller::Source::Rubygems
                                              | Runners::Ruby::GemInstaller::Source::Git

module Runners::Ruby::GemInstaller::Source
  def self.create: (gems_item) -> source_type
end

class Runners::Ruby::GemInstaller::Source::Base
  def rubygems?: -> bool
  def git?: -> bool
  def default?: -> bool
end

class Runners::Ruby::GemInstaller::Source::Rubygems < Runners::Ruby::GemInstaller::Source::Base
  attr_reader source: String

  def initialize: (?String) -> any
end

class Runners::Ruby::GemInstaller::Source::Git < Runners::Ruby::GemInstaller::Source::Base
  attr_reader repo: String
  attr_reader ref: String?
  attr_reader branch: String?
  attr_reader tag: String?

  def initialize: (String, ?ref: String, ?branch: String, ?tag: String) -> any
end

class Runners::Ruby::LockfileLoader
  attr_reader root_dir: Pathname
  attr_reader shell: Shell

  def initialize: (root_dir: Pathname, shell: Shell) -> any
  def ensure_lockfile: <'x> () { (Lockfile) -> 'x } -> 'x
  def gemfile_path: -> Pathname
  def gemfile_lock_path: -> Pathname
  def generate_lockfile: (Pathname) -> Pathname?
end

class Runners::Ruby::LockfileLoader::Lockfile
  attr_reader specs: Array<GemInstaller::Spec>

  def initialize: (String?) -> any
  def spec_exists?: (GemInstaller::Spec | String) -> bool
  def locked_version: (GemInstaller::Spec | String) -> String?
  def locked_version!: (GemInstaller::Spec | String) -> String
  def satisfied_by?: (GemInstaller::Spec | String, Hash<String, Array<String>>) -> bool
  def find_spec: (GemInstaller::Spec | String) -> GemInstaller::Spec?
end

class Runners::Ruby::LockfileLoader::Lockfile::UnsupportedSourceError < StandardError
  attr_reader name: String
  attr_reader source: any

  def initialize: (name: String, source: any) -> any
end

module Runners::Ruby::LockfileParser
  def self.parse: (String) -> Bundler::LockfileParser
end
