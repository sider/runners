class Runners::Options
  attr_reader stdout: ::IO
  attr_reader stderr: ::IO
  attr_reader source: Options::GitSource
  attr_reader head_key: String?
  attr_reader base: String?
  attr_reader base_key: String?
  attr_reader outputs: Array<String>
  attr_reader ssh_key: String?

  def initialize: (String, ::IO, ::IO) -> any
  def io: () -> Runners::IO
  def parse_options: (String) -> Hash<Symbol, any>
end

class Runners::Options::GitSource
  attr_reader head: String
  attr_reader base: String?
  attr_reader git_url: String
  attr_reader git_url_userinfo: String?
  attr_reader refspec: Array<String>

  def initialize: (head: String, base: String?, git_url: String,
                   git_url_userinfo: String?, refspec: Array<String> | String | nil) -> any
end
