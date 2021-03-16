module Runners
  class Ruby::GemInstaller
    class Source
      def self.default
        new
      end

      attr_reader :uri
      attr_reader :repo, :ref, :branch, :tag # for Git

      def initialize(uri: nil, git: nil)
        if git && !git[:repo]
          raise ArgumentError, "Required repository for Git source"
        end

        @uri = uri || Gem::DEFAULT_HOST

        git ||= {}
        @repo = git[:repo]
        @ref = git[:ref]
        @branch = git[:branch]
        @tag = git[:tag]
      end

      def git?
        !!repo
      end

      def default?
        uri == Gem::DEFAULT_HOST
      end

      def ==(other)
        self.class == other.class &&
          uri == other.uri &&
          repo == other.repo &&
          ref == other.ref &&
          branch == other.branch &&
          tag == other.tag
      end
      alias eql? ==

      def hash
        uri.hash ^ repo.hash ^ ref.hash ^ branch.hash ^ tag.hash
      end
    end
  end
end
