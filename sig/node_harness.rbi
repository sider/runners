class NodeHarness::Location
  attr_reader start_line: Integer
  attr_reader start_column: Integer?
  attr_reader end_line: Integer?
  attr_reader end_column: Integer?

  def initialize: (start_line: Integer, start_column: Integer | nil, end_line: Integer | nil, end_column: Integer | nil) -> any
  def valid?: () -> bool
  def ensure_validity: <'a> { (self) -> 'a } -> 'a
                     | -> self
  def as_json: () -> any
  def self.from_json: (any) -> Location
end

class NodeHarness::Location::InvalidLocationError
  attr_reader location: Location
  def initialize: (location: Location) -> any
end

type issue = NodeHarness::Issues::Identified | NodeHarness::Issues::Text | NodeHarness::Issues::Structured

class NodeHarness::Issues::InvalidIssueError
  attr_reader issue: issue
  def initialize: (issue: issue) -> issue
end

class NodeHarness::Issues::Base
  attr_reader path: Pathname
  attr_reader location: Location?
  attr_reader id: String

  def ensure_validity: () -> self
                     | <'a> { (self) -> 'a } -> 'a
  def eql?: (any) -> any
  def hash: () -> any
  def valid?: () -> bool
  def as_json: () -> any
end

class NodeHarness::Issues::Identified < NodeHarness::Issues::Base
  def initialize: (path: Pathname, location: Location?, id: String) -> any
end

class NodeHarness::Issues::Structured < NodeHarness::Issues::Base
  attr_reader object: any

  def initialize: (path: Pathname, location: Location?, id: String, object: any, schema: any) -> any
  def test_schema: (any, any) -> bool
end

class NodeHarness::Issues::Structured::InvalidObject
  attr_reader object: any
  def initialize: (object: any) -> any
end

class NodeHarness::Issues::Text < NodeHarness::Issues::Base
  attr_reader message: String
  attr_reader links: Array<String>
  def initialize: (path: Pathname, location: Location?, id: String, message: String, links: Array<String>) -> any
end

interface NodeHarness::_Writer
  def <<: (Schema::Types::any_trace) -> void
end

class NodeHarness::TraceWriter
  attr_reader writer: _Writer
  def initialize: (writer: _Writer) -> any

  def command_line: (Array<String>, ?recorded_at: Time) -> void
  def status: (any, ?recorded_at: Time) -> void
  def stdout: (String, ?recorded_at: Time, ?max_length: Integer) -> void
  def stderr: (String, ?recorded_at: Time, ?max_length: Integer) -> void
  def message: (String, ?recorded_at: Time, ?max_length: Integer) -> void
             | <'x> (String, ?recorded_at: Time, ?max_length: Integer) { -> 'x } -> 'x
  def header: (String, ?recorded_at: Time) -> void
  def warning: (String, ?file: any, ?recorded_at: Time) -> void
  def ci_config: (Hash<any, any>, ?recorded_at: Time) -> void
  def error: (String, ?recorded_at: Time, ?max_length: Integer) -> void
  def <<: (any) -> void
  def each_slice: (String, size: Integer) { (String) -> void } -> void
end

class NodeHarness::Analyzer
  attr_reader name: String
  attr_reader version: String
  def initialize: (name: String, version: String) -> any
  def valid?: () -> bool
  def as_json: () -> Hash<any, any>
end

type result = NodeHarness::Results::Success
            | NodeHarness::Results::Failure
            | NodeHarness::Results::MissingFilesFailure
            | NodeHarness::Results::Error

class NodeHarness::Results::Base
  attr_reader guid: String
  attr_reader timestamp: Time

  def initialize: (guid: String) -> any
  def as_json: () -> Hash<any, any>
  def valid?: () -> bool
end

class NodeHarness::Results::Success < NodeHarness::Results::Base
  attr_reader issues: Array<issue>
  attr_reader analyzer: Analyzer

  def initialize: (guid: String, analyzer: Analyzer) -> any
  def add_issue: (issue) -> void
  def (constructor) filter_issue: { (issue) -> bool } -> instance
end

class NodeHarness::Results::Success::InvalidIssue
  attr_reader issue: issue
  def initialize: (issue: issue) -> any
end

class NodeHarness::Results::Failure < NodeHarness::Results::Base
  attr_reader message: String
  attr_reader analyzer: Analyzer?
  def initialize: (guid: String, message: String, ?analyzer: Analyzer?) -> any
end

class NodeHarness::Results::MissingFilesFailure < NodeHarness::Results::Base
  attr_reader files: Array<Pathname>
  def initialize: (guid: String, files: Array<Pathname>) -> any
end

class NodeHarness::Results::Error < NodeHarness::Results::Base
  attr_reader exception: any
  def initialize: (guid: String, exception: any) -> any
end

class NodeHarness::Changes
  attr_reader changed_files: Array<ChangedFile>
  attr_reader unchanged_paths: Array<Pathname>
  attr_reader untracked_paths: Array<Pathname>

  def initialize: (changed_files: Array<ChangedFile>,
                   unchanged_paths: Array<Pathname>,
                   untracked_paths: Array<Pathname>) -> any
  def delete_unchanged: (dir: Pathname, ?except: Array<String>, ?only: Array<String>) { (Pathname) -> void }-> void
  def self.calculate: (base_dir: Pathname, head_dir: Pathname, working_dir: Pathname) -> instance
end

class NodeHarness::Changes::ChangedFile
  attr_reader path: Pathname
  def initialize: (path: Pathname) -> any
end

type prepare_type = :base | :head

class NodeHarness::Workspace
  attr_reader working_dir: Pathname
  attr_reader base_dir: Pathname
  attr_reader head_dir: Pathname
  attr_reader git_ssh_path: String?

  def initialize: (working_dir: Pathname, head_dir: Pathname, base_dir: Pathname, git_ssh_path: String?) -> any

  def calculate_changes: () -> Changes
  def self.open: <'a> (base: String?, base_key: String?, head: String, head_key: String?, ssh_key: String?, working_dir: Pathname, trace_writer: TraceWriter) { (instance) -> 'a } -> 'a
  def self.prepare_ssh: <'a> (String?, trace_writer: TraceWriter) { (String?) -> 'a } -> 'a
  def self.prepare_in_dir: (prepare_type, String, String?, Pathname, trace_writer: TraceWriter) -> void
  def self.decrypt: <'a> (Pathname, String?, trace_writer: TraceWriter) { (Pathname) -> 'a } -> 'a
  def self.decrypt_by_openssl: (Pathname, String, Pathname) -> void
  def self.extract: (Pathname, Pathname, trace_writer: TraceWriter) -> void
  def self.download: <'a> (URI) { (any) -> 'a } -> 'a
end

class NodeHarness::Workspace::DownloadError
end

class NodeHarness::Processor
  attr_reader guid: String
  attr_reader working_dir: Pathname
  attr_reader git_ssh_path: String
  attr_reader trace_writer: TraceWriter
  attr_reader shell: Shell
  attr_reader warnings: Array<any>
  attr_reader ci_config: any
  attr_reader ci_config_for_collect: any

  def initialize: (guid: any, working_dir: any, git_ssh_path: any, trace_writer: TraceWriter) -> any
  def relative_path: (String | Pathname, ?from: Pathname) -> Pathname
  def setup: () { -> result } -> result
  def analyze: (Changes) -> result
  def ci_config_path: () -> Pathname
  def ci_config_path_name: () -> String
  def ci_section: (?Hash<any, any>) -> Hash<any, any>
  def push_root_dir: <'x> { -> 'x } -> 'x
  def ensure_files: (*Pathname) { (Pathname) -> result } -> result
  def ensure_runner_config_schema: <'x> (any) { ('x) -> result } -> result
  def push_dir: <'x> (Pathname) { -> 'x } -> 'x
  def current_dir: () -> Pathname

  def capture3: (String, *String) -> [String, String, Process::Status]
  def capture3!: (String, *String) -> [String, String]
  def capture3_with_retry!: (String, *String, ?tries: Integer) -> [String, String]

  def capture3_trace: (String, *String) -> [String, String, Process::Status]

  def push_env_hash: <'x> (Hash<String, String?>) { -> 'x } -> 'x
  def env_hash: -> Hash<String, String?>

  def delete_unchanged_files: (Changes, ?except: Array<String>, ?only: Array<String>) -> void
  def add_warning: (String, ?file: String?) -> any
  def self.ci_config_section_name: () -> String
  def with_analyzer: <'x> (Analyzer?) { () -> 'x } -> 'x
  def analyzer: -> Analyzer?
  def analyzer!: -> Analyzer
  def analyzer_version: -> String
  def build_field_reference_from_path: (StrongJSON::Type::ErrorPath) -> String
  def root_dir: -> Pathname
  def directory_traversal_attack?: (String) -> bool
end

class NodeHarness::Shell
  attr_reader trace_writer: TraceWriter
  attr_reader env_hash_stack: Array<Hash<String, String?>>
  attr_reader dir_stack: Array<Pathname>

  def initialize: (current_dir: Pathname, env_hash: Hash<String, String?>, trace_writer: TraceWriter) -> any

  def capture3: (String, *String) -> [String, String, Process::Status]
  def capture3!: (String, *String) -> [String, String]
  def capture3_with_retry!: (String, *String, ?tries: Integer) -> [String, String]
  def capture3_trace: (String, *String) -> [String, String, Process::Status]

  def push_dir: <'x> (Pathname) { -> 'x } -> 'x
  def current_dir: () -> Pathname

  def push_env_hash: <'x> (Hash<String, String?>) { -> 'x } -> 'x
  def env_hash: -> Hash<String, String?>
end

class NodeHarness::Shell::ExecError
  attr_reader type: Symbol
  attr_reader args: Array<String>
  attr_reader stdout_str: String
  attr_reader stderr_str: String
  attr_reader status: Process::Status
  attr_reader dir: Pathname

  def initialize: (type: Symbol, args: Array<String>, stdout_str: String, stderr_str: String, status: Process::Status, dir: Pathname) -> any
end

class NodeHarness::Harness
  attr_reader guid: String
  attr_reader processor_class: Processor.class constructor
  attr_reader workspace: Workspace
  attr_reader trace_writer: TraceWriter
  attr_reader warnings: Array<String>
  attr_reader ci_config: any

  def initialize: (guid: String, processor_class: Processor.class constructor, workspace: Workspace, trace_writer: TraceWriter) -> any
  def run: () -> any
  def ensure_result: { -> result } -> result
end

class NodeHarness::Harness::InvalidResult
  attr_reader result: result
  def initialize: (result: result) -> any
end

class NodeHarness::CLI
  attr_reader stdout: IO
  attr_reader stderr: IO
  attr_reader entrypoint: Pathname
  attr_reader base: String?
  attr_reader base_key: String?
  attr_reader head: String
  attr_reader head_key: String?
  attr_reader ssh_key: String
  attr_reader working_dir: String?
  attr_reader guid: String
  attr_reader analyzer: String

  def initialize: (argv: Array<String>, stdout: IO, stderr: IO) -> any

  def with_working_dir: <'x> { (Pathname) -> 'x } -> 'x
  def processor_class: () -> Processor.class
  def validate_options!: () -> self
  def validate_analyzer!: () -> void
  def run: () -> void
end

module NodeHarness
  def self.register_processor: (Processor.class constructor) -> void
  def self.processor: () -> Processor.class constructor
end

NodeHarness::VERSION: String

type NodeHarness::gems_item = {
  "name" => String,
  "version" => String?,
  "source" => String?,
  "git" => git_source?,
}

type NodeHarness::git_source = {
  "repo" => String,
  "ref" => String?,
  "branch" => String?,
  "tag" => String?,
}

module NodeHarness::Ruby : Processor
  # Install given gems and setup environment variables, and yield the block
  def install_gems: <'x> (Array<GemInstaller::Spec>, ?optionals: Array<GemInstaller::Spec>, constraints: Hash<String, Array<String>>) { (Hash<String, String>) -> 'x } -> 'x
  def default_specs: (Array<GemInstaller::Spec>, Hash<String, Array<String>>, LockfileLoader::Lockfile) -> Array<GemInstaller::Spec>
  def optional_specs: (Array<GemInstaller::Spec>, LockfileLoader::Lockfile) -> Array<GemInstaller::Spec>
  def user_specs: (Array<GemInstaller::Spec>, LockfileLoader::Lockfile) -> Array<GemInstaller::Spec>
end

NodeHarness::Ruby::GemInstaller::DEFAULT_SOURCE: String

class NodeHarness::Ruby::GemInstaller
  attr_reader trace_writer: TraceWriter
  attr_reader env_hash: Hash<String, String?>
  attr_reader gem_home: Pathname
  attr_reader specs: Array<Spec>
  attr_reader shell: Shell
  attr_reader constraints: Hash<String, Array<String>>

  def initialize: (shell: Shell,
                   home: Pathname,
                   ci_config_path_name: String,
                   specs: Array<Spec>,
                   constraints: Hash<String, Array<String>>,
                   trace_writer: TraceWriter) -> void
  def install!: <'x> { (Hash<String, String>) -> 'x } -> 'x

  def gemfile_path: -> Pathname
  def gemfile_content: () -> Array<String>
end

class NodeHarness::Ruby::GemInstaller::Spec
  attr_reader name: String
  attr_reader version: Array<String>
  attr_reader source: RubygemsSource | GitSource

  def initialize: (name: String, version: Array<String>, ?source: RubygemsSource | GitSource) -> any
  def override_by_lockfile: (LockfileLoader::Lockfile) -> self

  def self.from_gems: (Array<gems_item | String>) -> Array<Spec>
  def self.merge: (Array<Spec>, Array<Spec>) -> Array<Spec>
end

class NodeHarness::Ruby::GemInstaller::RubygemsSource
  attr_reader source: String

  def initialize: (String) -> any
  def ==: (any) -> bool
  def to_s: () -> String
end

class NodeHarness::Ruby::GemInstaller::GitSource
  attr_reader repo: String
  attr_reader ref: String?
  attr_reader branch: String?
  attr_reader tag: String?

  def initialize: (repo: String, ?ref: String?, ?branch: String?, ?tag: String?) -> any
  def ==: (any) -> bool
  def to_s: () -> String
end

class NodeHarness::Ruby::LockfileLoader
  attr_reader root_dir: Pathname
  attr_reader shell: Shell

  def initialize: (root_dir: Pathname, shell: Shell) -> any

  def gemfile_path: -> Pathname
  def ensure_lockfile: <'x> () { (Lockfile) -> 'x } -> 'x
end

class NodeHarness::Ruby::LockfileLoader::Lockfile
  attr_reader specs: Array<any>

  def initialize: (Pathname?) -> any

  def spec_exists?: (String) -> bool
  def locked_version: (String) -> String?
  def satisfied_by?: (String, Hash<String, Array<String>>) -> bool
end

class NodeHarness::Ruby::LockfileLoader::Lockfile::UnsupportedSourceError < StandardError
  attr_reader name: String
  attr_reader source: any

  def initialize: (name: String, source: any) -> any
end

type npm_install_option = bool | String

module NodeHarness::Nodejs : Processor
  def nodejs_analyzer_command: -> String
  def nodejs_analyzer_local_command: -> String
  def nodejs_analyzer_bin: -> String
  def nodejs_analyzer_locally_installed?: -> bool
  def nodejs_analyzer_version_via: (String) -> String
  def nodejs_analyzer_global_version: -> String
  def nodejs_analyzer_local_version: -> String
  def nodejs_analyzer_version: -> String
  def package_json_path: -> Pathname
  def package_json: -> Hash<Symbol, any>
  def package_lock_json_path: -> Pathname
  def yarn_lock_path: -> Pathname
  def install_nodejs_deps: (DefaultDependencies, constraints: Hash<String, Constraint>,
                            install_option: npm_install_option | nil) -> void

  # private
  def check_nodejs_runtime: -> void
  def check_nodejs_default_deps: (DefaultDependencies, Hash<String, Constraint>) -> void
  def check_duplicate_lockfiles: -> void
  def npm_install: (npm_install_option) -> void
  def yarn_install: (npm_install_option) -> void
  def check_installed_nodejs_deps: (Hash<String, Constraint>, Dependency) -> void
end
NodeHarness::Nodejs::REQUIRED_NODE_VERSIONS: Array<String>
NodeHarness::Nodejs::REQUIRED_NPM_VERSIONS: Array<String>
NodeHarness::Nodejs::REQUIRED_YARN_VERSIONS: Array<String>
NodeHarness::Nodejs::INSTALL_OPTION_NONE: bool
NodeHarness::Nodejs::INSTALL_OPTION_ALL: bool
NodeHarness::Nodejs::INSTALL_OPTION_PRODUCTION: String
NodeHarness::Nodejs::INSTALL_OPTION_DEVELOPMENT: String

class NodeHarness::Nodejs::Dependency
  attr_reader name: String
  attr_reader version: String
  def initialize: (name: String, version: String) -> any
end

class NodeHarness::Nodejs::DefaultDependencies
  attr_reader main: Dependency
  attr_reader extras: Array<Dependency>
  def initialize: (main: Dependency, ?extras: Array<Dependency>) -> any
  def all: -> Array<Dependency>
end

class NodeHarness::Nodejs::Constraint
  def initialize: (String, *String) -> any
  def satisfied_by?: (Dependency) -> bool
  def unsatisfied_by?: (Dependency) -> bool
end

class NodeHarness::Testing::Smoke
  attr_reader argv: any
  attr_reader data_container: any
  attr_reader data_smoke_path: any

  def docker_image: () -> any
  def entrypoint: () -> any
  def expectations: () -> any
  def initialize: (any) -> any
  def run: () -> any
  def run_test: (any, any, any) -> any
  def unify_result: (any, any, any) -> any
  def with_data_container: <'x> { () -> 'x } -> 'x
  def command_line: (any, any) -> any

  def self.add_test: (any, any, **any) { (Configuration) -> void } -> void
  def self.tests: () -> any
  def self.configs: () -> any

  # By UnificationAssertion (unification_assertion)
  def unify: (any) { (any) -> any } -> any
end

NodeHarness::Testing::Smoke::ROOT_DATA_DIR: Pathname

class NodeHarness::Testing::Smoke::Configuration
  attr_accessor ssh_key: String?
end
