module Runners
  module Tmpdir
    def mktmpdir
      Dir.mktmpdir do |dir|
        yield Pathname(dir)
      end
    end

    # TODO: We should unify `#mktmpdir` and `mktmpdir_as_pathname` but Steep checking fails...
    def mktmpdir_as_pathname
      Pathname(Dir.mktmpdir)
    end
  end
end
