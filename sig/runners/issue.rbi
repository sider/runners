class Runners::Issue
  attr_reader path: Pathname
  attr_reader location: Location?
  attr_reader id: String
  attr_reader message: String
  attr_reader links: Array<String>
  attr_reader object: any
  attr_reader git_blame_info: GitBlameInfo?

  def initialize: (path: Pathname,
                   location: Location?,
                   id: String,
                   message: String,
                   ?links: Array<String>,
                   ?object: any,
                   ?schema: any) -> void
  def as_json: () -> any
  def add_git_blame_info: (Workspace) -> void
end
