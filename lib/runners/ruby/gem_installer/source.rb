module Runners
  class Ruby::GemInstaller
    class Source
      DEFAULT = "https://rubygems.org".freeze
      private_constant :DEFAULT

      def self.default
        Rubygems.new(DEFAULT)
      end

      def self.create(gems_item)
        source = gems_item[:source]
        git_source = gems_item[:git]

        case
        when source.is_a?(String)
          Rubygems.new(source)
        when git_source.is_a?(Hash)
          Git.new(git_source)
        else
          default
        end
      end

      def rubygems?
        false
      end

      def git?
        false
      end

      def default?
        false
      end

      # @see https://bundler.io/man/gemfile.5.html#SOURCE
      class Rubygems < Source
        attr_reader :source

        def initialize(source)
          source or raise ArgumentError, "Required source for Rubygems source"

          super()
          @source = source
        end

        def rubygems?
          true
        end

        def default?
          source == DEFAULT
        end

        def ==(other)
          self.class == other.class && source == other.source
        end
        alias eql? ==

        def hash
          source.hash
        end

        def to_s
          "source \"#{source}\""
        end
      end
      private_constant :Rubygems

      # @see https://bundler.io/man/gemfile.5.html#GIT
      class Git < Source
        attr_reader :repo, :ref, :branch, :tag

        def initialize(params)
          repo = params[:repo] or raise ArgumentError, "Required repository for Git source"

          super()
          @repo = repo
          @ref = params[:ref]
          @branch = params[:branch]
          @tag = params[:tag]
        end

        def git?
          true
        end

        def ==(other)
          self.class == other.class && repo == other.repo && ref == other.ref && branch == other.branch && tag == other.tag
        end
        alias eql? ==

        def hash
          repo.hash ^ ref.hash ^ branch.hash ^ tag.hash
        end

        def to_s
          s = "git \"#{repo}\""
          s << ", ref: \"#{ref}\"" if ref
          s << ", branch: \"#{branch}\"" if branch
          s << ", tag: \"#{tag}\"" if tag
          s
        end
      end
      private_constant :Git
    end
  end
end
