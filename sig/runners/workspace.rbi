class Runners::Workspace
  include Tmpdir

  attr_reader options: Options
  attr_reader working_dir: Pathname
  attr_reader trace_writer: TraceWriter
  attr_reader shell: Shell

  def self.prepare: (options: Options, working_dir: Pathname, trace_writer: TraceWriter) -> instance
  def initialize: (options: Options, working_dir: Pathname, trace_writer: TraceWriter) -> any
  def open: <'a> () { (Pathname?, Changes) -> 'a } -> 'a
  def prepare_ssh: <'a> () { (Pathname?) -> 'a } -> 'a
  def prepare_base_source: (Pathname) -> void
  def prepare_head_source: (Pathname) -> void
  def decrypt: <'a> (Pathname, String?) { (Pathname) -> 'a } -> 'a
  def decrypt_by_openssl: (Pathname, String, Pathname) -> void
  def extract: (Pathname, Pathname) -> void
  def archive_source: () -> Options::ArchiveSource
  def git_source: () -> Options::GitSource
  def patches: () -> GitDiffParser::Patches?
  def range_git_blame_info: (String, Integer, Integer) -> Array<GitBlameInfo>
end

class Runners::Workspace::HTTP < Workspace
  def prepare_base_source: (Pathname) -> void
  def prepare_head_source: (Pathname) -> void
  def provision: (URI, Pathname, String?) -> void
  def download_with_retry: (URI) { (Pathname) -> void } -> void
  def download: (URI, dest: ::IO, max_retries: Integer, max_redirects: Integer) -> void
  def retryable_sleep: (Integer) -> Integer
end

class Runners::Workspace::File < Workspace
  def prepare_base_source: (Pathname) -> void
  def prepare_head_source: (Pathname) -> void
  def provision: (Pathname, Pathname, String?) -> void
end

class Runners::Workspace::Git < Workspace
  def prepare_base_source: (Pathname) -> void
  def prepare_head_source: (Pathname) -> void
  def remote_url: () -> URI
  def git_fetch_args: () -> Array<String>
  def try_count: () -> Integer
  def sleep_lambda: () -> (^(Integer) -> Numeric)
end
