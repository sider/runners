s = Runners::Testing::Smoke

default_version = Runners::VERSION

s.add_test_with_git_metadata(
  "success",
  { type: "success",
    issues: [
      {
        id: "metrics_fileinfo",
        path: "hello.rb",
        location: nil,
        message: "hello.rb: loc = 7, last commit datetime = 2021-01-01T10:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 7,
          last_committed_at: "2021-01-01T10:00:00+09:00"
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics File Info", version: default_version } }
)

s.add_test_with_git_metadata(
  "binary_files",
  { type: "success",
    issues: [
      {
        id: "metrics_fileinfo",
        path: "image.png",
        location: nil,
        message: "image.png: loc = (no info), last commit datetime = 2021-01-01T13:00:00+09:00",
        links: [],
        object: {
          lines_of_code: nil,
          last_committed_at: "2021-01-01T13:00:00+09:00"
        },
        git_blame_info: nil
      }, {
        id: "metrics_fileinfo",
        path: "no_text.txt",
        location: nil,
        message: "no_text.txt: loc = (no info), last commit datetime = 2021-01-01T14:00:00+09:00",
        links: [],
        object: {
          lines_of_code: nil,
          last_committed_at: "2021-01-01T14:00:00+09:00"
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics File Info", version: default_version } }
)

s.add_test_with_git_metadata(
  "unknown_extension",
  { type: "success",
    issues: [
      {
        id: "metrics_fileinfo",
        path: "foo.my_original_extension",
        location: nil,
        message: "foo.my_original_extension: loc = 2, last commit datetime = 2021-01-01T11:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 2,
          last_committed_at: "2021-01-01T11:00:00+09:00"
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics File Info", version: default_version } }
)

s.add_test_with_git_metadata(
  "multi_language",
  { type: "success",
    issues: [
      {
        id: "metrics_fileinfo",
        path: "euc_jp.txt",
        location: nil,
        message: "euc_jp.txt: loc = 1, last commit datetime = 2021-01-01T12:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 1,
          last_committed_at: "2021-01-01T12:00:00+09:00"
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "iso_2022_jp.txt",
        location: nil,
        message: "iso_2022_jp.txt: loc = 1, last commit datetime = 2021-01-01T13:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 1,
          last_committed_at: "2021-01-01T13:00:00+09:00"
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "shift_jis.txt",
        location: nil,
        message: "shift_jis.txt: loc = 1, last commit datetime = 2021-01-01T11:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 1,
          last_committed_at: "2021-01-01T11:00:00+09:00"
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "utf8.txt",
        location: nil,
        message: "utf8.txt: loc = 7, last commit datetime = 2021-01-01T10:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 7,
          last_committed_at: "2021-01-01T10:00:00+09:00"
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics File Info", version: default_version } }
)

s.add_test_with_git_metadata(
  "multi_commit",
  { type: "success",
    issues: [
      {
        id: "metrics_fileinfo",
        path: "hello.rb",
        location: nil,
        message: "hello.rb: loc = 9, last commit datetime = 2021-01-01T12:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 9,
          last_committed_at: "2021-01-01T12:00:00+09:00"
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics File Info", version: default_version } }
)

s.add_test_with_git_metadata(
  "directory_hierarchy",
  { type: "success",
    issues: [
      {
        id: "metrics_fileinfo",
        path: "README.txt",
        location: nil,
        message: "README.txt: loc = 2, last commit datetime = 2021-01-01T14:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 2,
          last_committed_at: "2021-01-01T14:00:00+09:00"
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "lib/about_libs.txt",
        location: nil,
        message: "lib/about_libs.txt: loc = 1, last commit datetime = 2021-01-01T14:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 1,
          last_committed_at: "2021-01-01T14:00:00+09:00"
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "lib/libbar/libbar.rb",
        location: nil,
        message: "lib/libbar/libbar.rb: loc = 5, last commit datetime = 2021-01-01T14:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 5,
          last_committed_at: "2021-01-01T14:00:00+09:00"
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "lib/libfoo/libfoo.rb",
        location: nil,
        message: "lib/libfoo/libfoo.rb: loc = 5, last commit datetime = 2021-01-01T14:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 5,
          last_committed_at: "2021-01-01T14:00:00+09:00"
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "src/main.rb",
        location: nil,
        message: "src/main.rb: loc = 5, last commit datetime = 2021-01-01T14:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 5,
          last_committed_at: "2021-01-01T14:00:00+09:00"
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "src/module_piyo/piyo.rb",
        location: nil,
        message: "src/module_piyo/piyo.rb: loc = 6, last commit datetime = 2021-01-01T14:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 6,
          last_committed_at: "2021-01-01T14:00:00+09:00"
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics File Info", version: default_version } }
)

s.add_test_with_git_metadata(
  "with_ignore_setting",
  { type: "success",
    issues: [
      {
        id: "metrics_fileinfo",
        path: "hello.rb",
        location: nil,
        message: "hello.rb: loc = 7, last commit datetime = 2021-01-01T10:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 7,
          last_committed_at: "2021-01-01T10:00:00+09:00"
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "sider.yml",
        location: nil,
        message: "sider.yml: loc = 2, last commit datetime = 2021-01-01T10:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 2,
          last_committed_at: "2021-01-01T10:00:00+09:00"
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics File Info", version: default_version } }
)
