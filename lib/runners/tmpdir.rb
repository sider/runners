module Runners
  module Tmpdir
    def mktmpdir
      if block_given?
        Dir.mktmpdir do |dir|
          yield Pathname(dir)
        end
      else
        Pathname(Dir.mktmpdir)
      end
    end
  end
end
