module Runners
  module CPlusPlus
    # @see https://github.com/github/linguist/blob/775b07d40c04ef6e0051a541886a8f1e30a892f4/lib/linguist/languages.yml#L532-L535
    # @see https://github.com/github/linguist/blob/775b07d40c04ef6e0051a541886a8f1e30a892f4/lib/linguist/languages.yml#L568-L584
    CPP_SOURCES_GLOB = "*.{c,cpp,c++,cc,cp,cxx}".freeze
    CPP_HEADERS_GLOB = "**/*.{h,h++,hh,hpp,hxx,inc,inl,ipp,tcc,tpp}".freeze
    private_constant :CPP_SOURCES_GLOB, :CPP_HEADERS_GLOB

    def config_include_path
      Array(config_linter[:'include-path'] || find_paths_containing_headers).map { |v| "-I#{v}" }
    end

    def cpp_file?(path)
      path.fnmatch?(CPP_SOURCES_GLOB, File::FNM_EXTGLOB | File::FNM_CASEFOLD)
    end

    private

    def find_paths_containing_headers
      Pathname.glob(CPP_HEADERS_GLOB, File::FNM_EXTGLOB | File::FNM_CASEFOLD)
        .filter_map { |path| path.parent.to_path if path.file? }
        .uniq
    end
  end
end
