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
      gdp = patches # NOTE: This assignment is required for typecheck by Steep
      if gdp
        location = issue.location
        # NOTE: #find_patch_by_file omits just renamed files.
        # @see https://github.com/packsaddle/ruby-git_diff_parser/issues/272
        patch = gdp.find_patch_by_file(issue.path.to_s)
        if patch && location
          patch.changed_lines.one? { |line| location.start_line == line.number }
        elsif patch
          true
        else
          false
        end
      else
        changed_paths.member?(issue.path)
      end
    end

    def self.calculate(working_dir:)
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
