module Runners
  class Changes
    attr_reader :changed_paths
    attr_reader :unchanged_paths
    attr_reader :patches

    def initialize(changed_paths:, unchanged_paths:, patches:)
      @changed_paths = Set.new(changed_paths).freeze
      @unchanged_paths = Set.new(unchanged_paths).freeze
      @patches = patches
    end

    def delete_unchanged(dir:, except: [], only: [])
      unchanged_paths
        .filter { |file| deletable?(dir, file, except, only) }
        .each { |file| dir.join(file).delete }
        .to_a
    end

    private def deletable?(dir, file, except, only)
      flags = File::FNM_DOTMATCH | File::FNM_EXTGLOB
      if only.empty? || only.any? { |pattern| file.fnmatch?(pattern, flags) }
        if except.none? { |pattern| file.fnmatch?(pattern, flags) }
          return dir.join(file).file?
        end
      end

      false
    end

    def include?(issue)
      git_diff_patches = patches
      if git_diff_patches
        # NOTE: #find_patch_by_file omits just renamed files.
        # @see https://github.com/packsaddle/ruby-git_diff_parser/issues/272
        changed_lines = changed_lines_by_file(git_diff_patches, issue.path.to_path)
        location = issue.location
        if location
          changed_lines.any? { |line| location.include_line?(line) }
        else
          !changed_lines.empty?
        end
      else
        changed_paths.member?(issue.path)
      end
    end

    private def changed_lines_by_file(patches, path)
      # NOTE: Cache for so many issues
      @changed_lines_cache ||= {}
      hit = @changed_lines_cache[path]
      if hit
        hit
      else
        lines = patches.find_patch_by_file(path)&.changed_lines&.map(&:number) || []
        lines.freeze
        @changed_lines_cache[path] = lines
        lines
      end
    end

    def self.all(working_dir:)
      new(changed_paths: all_files_in(working_dir).sort,
          unchanged_paths: [],
          patches: nil)
    end

    def self.calculate_by_patches(working_dir:, patches:)
      all_files = all_files_in(working_dir)
      changed_files = patches.files.map { |f| Pathname(f) }

      new(changed_paths: changed_files.sort,
          unchanged_paths: (all_files - changed_files).sort,
          patches: patches)
    end

    def self.all_files_in(basedir)
      basedir.glob("**/*", File::FNM_DOTMATCH).filter_map do |file|
        if file.file? && !file.fnmatch?("**/.git/*", File::FNM_DOTMATCH)
          file.relative_path_from(basedir)
        end
      end
    end
    private_class_method :all_files_in
  end
end
