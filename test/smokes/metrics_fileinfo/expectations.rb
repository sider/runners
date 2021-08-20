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
          last_committed_at: "2021-01-01T10:00:00+09:00",
          number_of_commits: 1,
          occurrence: 0,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T13:00:00+09:00",
          number_of_commits: 1,
          occurrence: 0,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T14:00:00+09:00",
          number_of_commits: 1,
          occurrence: 1,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T11:00:00+09:00",
          number_of_commits: 0,
          occurrence: 0,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T12:00:00+09:00",
          number_of_commits: 3,
          occurrence: 1,
          additions: 1,
          deletions: 0
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
          last_committed_at: "2021-01-01T13:00:00+09:00",
          number_of_commits: 3,
          occurrence: 1,
          additions: 1,
          deletions: 0
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
          last_committed_at: "2021-01-01T11:00:00+09:00",
          number_of_commits: 3,
          occurrence: 1,
          additions: 1,
          deletions: 0
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
          last_committed_at: "2021-01-01T10:00:00+09:00",
          number_of_commits: 3,
          occurrence: 0,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T12:00:00+09:00",
          number_of_commits: 2,
          occurrence: 2,
          additions: 2,
          deletions: 0
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
          last_committed_at: "2021-01-01T14:00:00+09:00",
          number_of_commits: 0,
          occurrence: 0,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T14:00:00+09:00",
          number_of_commits: 0,
          occurrence: 0,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T14:00:00+09:00",
          number_of_commits: 0,
          occurrence: 0,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T14:00:00+09:00",
          number_of_commits: 0,
          occurrence: 0,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T14:00:00+09:00",
          number_of_commits: 0,
          occurrence: 0,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T14:00:00+09:00",
          number_of_commits: 0,
          occurrence: 0,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T10:00:00+09:00",
          number_of_commits: 0,
          occurrence: 0,
          additions: 0,
          deletions: 0
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
          last_committed_at: "2021-01-01T10:00:00+09:00",
          number_of_commits: 0,
          occurrence: 0,
          additions: 0,
          deletions: 0
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics File Info", version: default_version } }
)

s.add_test_with_git_metadata(
  "with_metrics_ignore_setting",
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
          last_committed_at: "2021-01-01T10:00:00+09:00",
          number_of_commits: 1,
          occurrence: 0,
          additions: 0,
          deletions: 0
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "sider.yml",
        location: nil,
        message: "sider.yml: loc = 4, last commit datetime = 2021-08-03T02:19:42+00:00",
        links: [],
        object: {
          lines_of_code: 4,
          last_committed_at: "2021-08-03T02:19:42+00:00",
          number_of_commits: 1,
          occurrence: 1,
          additions: 4,
          deletions: 2
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics File Info", version: default_version } }
)

s.add_test_with_git_metadata(
  "churn",
  { type: "success",
    issues: [
      {
        id: "metrics_fileinfo",
        path: "foo/test.txt",
        location: nil,
        message: "foo/test.txt: loc = 5, last commit datetime = 2021-03-04T04:23:45+00:00",
        links: [],
        object: {
          lines_of_code: 5,
          last_committed_at: "2021-03-04T04:23:45+00:00",
          number_of_commits: 4,
          occurrence: 2,
          additions: 5,
          deletions: 0
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "image.png",
        location: nil,
        message: "image.png: loc = (no info), last commit datetime = 2021-03-04T04:23:45+00:00",
        links: [],
        object: {
          lines_of_code: nil,
          last_committed_at: "2021-03-04T04:23:45+00:00",
          number_of_commits: 4,
          occurrence: 1,
          additions: 0,
          deletions: 0
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "sample.c",
        location: nil,
        message: "sample.c: loc = 2, last commit datetime = 2021-03-05T05:23:45+00:00",
        links: [],
        object: {
          lines_of_code: 2,
          last_committed_at: "2021-03-05T05:23:45+00:00",
          number_of_commits: 4,
          occurrence: 3,
          additions: 5,
          deletions: 3
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics File Info", version: default_version } }
)

s.add_test_with_git_metadata(
  "churn_days",
  { type: "success",
    issues: [
      {
        id: "metrics_fileinfo",
        path: "bar/hello.java",
        location: nil,
        message: "bar/hello.java: loc = 2, last commit datetime = 2020-05-22T12:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 2,
          last_committed_at: "2020-05-22T12:00:00+09:00",
          number_of_commits: 112,
          occurrence: 0,
          additions: 0,
          deletions: 0
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "foo/test.txt",
        location: nil,
        message: "foo/test.txt: loc = 3, last commit datetime = 2020-06-20T12:00:00+09:00",
        links: [],
        object: {
          lines_of_code: 3,
          last_committed_at: "2020-06-20T12:00:00+09:00",
          number_of_commits: 112,
          occurrence: 111,
          additions: 113,
          deletions: 113
        },
        git_blame_info: nil
      },
      {
        id: "metrics_fileinfo",
        path: "sample.c",
        location: nil,
        message: "sample.c: loc = 1, last commit datetime = 2020-08-23T12:34:56+09:00",
        links: [],
        object: {
          lines_of_code: 1,
          last_committed_at: "2020-08-23T12:34:56+09:00",
          number_of_commits: 112,
          occurrence: 2,
          additions: 1,
          deletions: 3
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "Metrics File Info", version: default_version } }
)

s.add_test_with_git_metadata(
  "gitattributes",
  type: "success",
  issues: [
    {
      id: "metrics_fileinfo",
      path: ".foorc",
      location: nil,
      message: ".foorc: loc = 1, last commit datetime = 2021-07-08T13:49:29+09:00",
      links: [],
      object: {
        lines_of_code: 1,
        last_committed_at: "2021-07-08T13:49:29+09:00",
        number_of_commits: 0,
        occurrence: 0,
        additions: 0,
        deletions: 0
      },
      git_blame_info: nil
    },
    {
      id: "metrics_fileinfo",
      path: ".gitattributes",
      location: nil,
      message: ".gitattributes: loc = 1, last commit datetime = 2021-07-08T13:49:29+09:00",
      links: [],
      object: {
        lines_of_code: 1,
        last_committed_at: "2021-07-08T13:49:29+09:00",
        number_of_commits: 0,
        occurrence: 0,
        additions: 0,
        deletions: 0
      },
      git_blame_info: nil
    },
    {
      id: "metrics_fileinfo",
      path: "readme.md",
      location: nil,
      message: "readme.md: loc = 1, last commit datetime = 2021-07-08T13:49:29+09:00",
      links: [],
      object: {
        lines_of_code: 1,
        last_committed_at: "2021-07-08T13:49:29+09:00",
        number_of_commits: 0,
        occurrence: 0,
        additions: 0,
        deletions: 0
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics File Info", version: default_version }
)

s.add_test_with_git_metadata(
  "unicode_filepath",
  type: "success",
  issues: [
    {
      id: "metrics_fileinfo",
      path: "<img onerror=\"alert('ok')\" src=\"foo.png\">.js",
      location: nil,
      message: "<img onerror=\"alert('ok')\" src=\"foo.png\">.js: loc = (no info), last commit datetime = 2021-07-20T10:26:16+09:00",
      links: [],
      object: {
        lines_of_code: nil,
        last_committed_at: "2021-07-20T10:26:16+09:00",
        number_of_commits: 0,
        occurrence: 0,
        additions: 0,
        deletions: 0
      },
      git_blame_info: nil
    },
    {
      id: "metrics_fileinfo",
      path: "goodcheck copy.yml",
      location: nil,
      message: "goodcheck copy.yml: loc = (no info), last commit datetime = 2021-07-20T10:26:16+09:00",
      links: [],
      object: {
        lines_of_code: nil,
        last_committed_at: "2021-07-20T10:26:16+09:00",
        number_of_commits: 0,
        occurrence: 0,
        additions: 0,
        deletions: 0
      },
      git_blame_info: nil
    },
    {
      id: "metrics_fileinfo",
      path: "master-test/📁/second_depth_file.js",
      location: nil,
      message: "master-test/📁/second_depth_file.js: loc = 2, last commit datetime = 2021-07-20T10:26:16+09:00",
      links: [],
      object: {
        lines_of_code: 2,
        last_committed_at: "2021-07-20T10:26:16+09:00",
        number_of_commits: 0,
        occurrence: 0,
        additions: 0,
        deletions: 0
      },
      git_blame_info: nil
    },
    {
      id: "metrics_fileinfo",
      path: "master-test/🗄️.js",
      location: nil,
      message: "master-test/🗄️.js: loc = 2, last commit datetime = 2021-07-20T10:26:16+09:00",
      links: [],
      object: {
        lines_of_code: 2,
        last_committed_at: "2021-07-20T10:26:16+09:00",
        number_of_commits: 0,
        occurrence: 0,
        additions: 0,
        deletions: 0
      },
      git_blame_info: nil
    },
    {
      id: "metrics_fileinfo",
      path: "zzzzz;' SHOW TABLES; SELECT '.txt",
      location: nil,
      message: "zzzzz;' SHOW TABLES; SELECT '.txt: loc = (no info), last commit datetime = 2021-07-20T10:26:16+09:00",
      links: [],
      object: {
        lines_of_code: nil,
        last_committed_at: "2021-07-20T10:26:16+09:00",
        number_of_commits: 0,
        occurrence: 0,
        additions: 0,
        deletions: 0
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Metrics File Info", version: default_version }
)
