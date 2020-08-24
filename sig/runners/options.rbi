class Runners::Options
  attr_reader stdout: ::IO
  attr_reader stderr: ::IO
  attr_reader source: Options::GitSource
  attr_reader head_key: String?
  attr_reader base: String?
  attr_reader base_key: String?
  attr_reader outputs: Array<String>
  attr_reader ssh_key: String?

  def initialize: (::IO, ::IO) -> any
  def io: () -> Runners::IO
  def parse_options: () -> Hash<Symbol, any>
end

class Runners::Options::GitSource
  attr_accessor head: String
  attr_accessor base: String?
  attr_accessor git_url: String
  attr_accessor git_url_userinfo: String?
  attr_accessor pull_number: Integer?

  def initialize: (head: String, ?base: String, git_url: String,
                   ?git_url_userinfo: String, ?pull_number: Integer) -> any
end
