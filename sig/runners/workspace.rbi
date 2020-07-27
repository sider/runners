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
  def prepare_head_source: () -> void
  def patches: () -> GitDiffParser::Patches
  def range_git_blame_info: (String, Integer, Integer) -> Array<GitBlameInfo>
end

class Runners::Workspace::Git < Workspace
  # private
  def git_source: () -> Options::GitSource
  def remote_url: () -> URI
  def git_fetch_args: () -> Array<String>
  def try_count: () -> Integer
  def sleep_lambda: () -> (^(Integer) -> Numeric)
end
