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

    def deletable?(dir, file, except, only)
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

    def self.calculate(base_dir:, head_dir:, patches:)
      return calculate_by_patches(head_dir, patches) if patches

      changed_paths = []
      unchanged_paths = []

      head_dir.glob("**/*", File::FNM_DOTMATCH).filter(&:file?).each do |head_path|
        relative_path = head_path.relative_path_from(head_dir)
        base_path = base_dir / relative_path

        if base_path.file?
          head_digest = Digest::SHA1.new.file(head_path.to_s)
          base_digest = Digest::SHA1.new.file(base_path.to_s)
          if head_digest == base_digest
            unchanged_paths << relative_path
          else
            changed_paths << relative_path
          end
        else
          changed_paths << relative_path
        end
      end

      new(changed_paths: changed_paths.sort!,
          unchanged_paths: unchanged_paths.sort!,
          patches: patches)
    end

    def self.calculate_by_patches(working_dir, patches)
      all_files = working_dir
        .glob("**/*", File::FNM_DOTMATCH)
        .filter_map { |f| f.relative_path_from(working_dir) if f.file? }

      changed_paths = patches.files.map { |f| Pathname(f) }

      new(changed_paths: changed_paths.sort!,
          unchanged_paths: (all_files - changed_paths).sort!,
          patches: patches)
    end
  end
end
