module Runners
  class GitBlameInfo
    # @param porcelain_output [String] The output of git-blame(1) with -p option
    # @see https://www.git-scm.com/docs/git-blame#_the_porcelain_format
    def self.parse(porcelain_output)
      porcelain_output = porcelain_output.force_encoding(Encoding::ASCII_8BIT)
      headers = porcelain_output.scan(/^([a-z0-9]{40}) (\d+) (\d+)/)
      contents = porcelain_output.scan(/^\t(.*)$/).flatten
      headers.zip(contents).map do |item|
        commit, original_line, final_line, content = item.flatten
        new(commit: commit, original_line: Integer(original_line), final_line: Integer(final_line), line_hash: Digest::SHA1.hexdigest(content))
      end
    end

    attr_reader :commit, :original_line, :final_line, :line_hash

    def initialize(commit:, original_line:, final_line:, line_hash:)
      @commit = commit
      @original_line = original_line
      @final_line = final_line
      @line_hash = line_hash
    end

    def ==(other)
      self.class == other.class &&
        commit == other.commit &&
        original_line == other.original_line &&
        final_line == other.final_line &&
        line_hash == other.line_hash
    end
    alias eql? ==

    def hash
      commit.hash ^ original_line.hash ^ final_line.hash ^ line_hash.hash
    end

    def as_json
      {
        commit: commit,
        original_line: original_line,
        final_line: final_line,
        line_hash: line_hash,
      }
    end
  end
end
