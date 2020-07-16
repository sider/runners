module Runners
  module CPlusPlus
    def config_include_path
      Array(config_linter[:'include-path'] || find_paths_containing_headers).map { |v| "-I#{v}" }
    end

    private

    # @see https://github.com/github/linguist/blob/775b07d40c04ef6e0051a541886a8f1e30a892f4/lib/linguist/languages.yml#L532-L535
    # @see https://github.com/github/linguist/blob/775b07d40c04ef6e0051a541886a8f1e30a892f4/lib/linguist/languages.yml#L568-L584
    GLOB_HEADERS = "**/*.{h,h++,hh,hpp,hxx,inc,inl,ipp,tcc,tpp}".freeze

    def find_paths_containing_headers
      Pathname.glob(GLOB_HEADERS, File::FNM_EXTGLOB | File::FNM_CASEFOLD)
        .filter_map { |path| path.parent.to_path if path.file? }
        .uniq
    end
  end
end
