module Runners
  # @type var _: untyped
  GitBlameInfo = _ = Struct.new(:commit, :original_line, :final_line, :line_hash, keyword_init: true) do
    # @param porelain_output [String] The output of git-blame(1) with -p option
    # @see https://www.git-scm.com/docs/git-blame#_the_porcelain_format
    def self.parse(porelain_output)
      headers = porelain_output.scan(/^([a-z0-9]{40}) (\d+) (\d+)/)
      contents = porelain_output.scan(/^\t(.*)$/).flatten
      headers.zip(contents).map do |item|
        commit, original_line, final_line, content = item.flatten
        new(commit: commit, original_line: Integer(original_line), final_line: Integer(final_line), line_hash: Digest::SHA1.hexdigest(content))
      end
    end
  end
end
