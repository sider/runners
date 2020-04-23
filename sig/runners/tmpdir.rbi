module Runners::Tmpdir
  include Kernel

  def mktmpdir: <'x> { (Pathname) -> 'x } -> 'x
  def mktmpdir_as_pathname: -> Pathname
end
