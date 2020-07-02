s = Runners::Testing::Smoke

default_version = "1.5.2"

s.add_test(
  "default",
  type: "success",
  issues: [
    {
      id: "legal/copyright",
      path: "src/test.cpp",
      location: nil,
      message: 'No copyright message found.  You should have a line: "Copyright [year] <Copyright Owner>"',
      links: [],
      object: { confidence: "5" },
      git_blame_info: nil
    },
    {
      id: "whitespace/braces",
      path: "foo.cc",
      location: { start_line: 3 },
      message: "{ should almost always be at the end of the previous line",
      links: [],
      object: { confidence: "4" },
      git_blame_info: nil
    },
    {
      id: "whitespace/tab",
      path: "foo.cc",
      location: { start_line: 4 },
      message: "Tab found; better to use spaces",
      links: [],
      object: { confidence: "1" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "cpplint", version: default_version }
)

s.add_test("official_samples", type: "success", issues: :_, analyzer: { name: "cpplint", version: default_version })

s.add_test("option_exclude", type: "success", issues: [], analyzer: { name: "cpplint", version: default_version })

s.add_test("option_exclude_multi", type: "success", issues: [], analyzer: { name: "cpplint", version: default_version })

s.add_test("option_extensions", type: "success", issues: [], analyzer: { name: "cpplint", version: default_version })

s.add_test(
  "option_filter",
  type: "success",
  issues: [
    {
      id: "whitespace/braces",
      path: "test.cpp",
      location: { start_line: 2 },
      message: "{ should almost always be at the end of the previous line",
      links: [],
      object: { confidence: "4" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "cpplint", version: default_version }
)

s.add_test("option_headers", type: "success", issues: [], analyzer: { name: "cpplint", version: default_version })

s.add_test(
  "option_linelength",
  type: "success",
  issues: [
    {
      id: "whitespace/line_length",
      path: "test.cpp",
      location: nil,
      message: "Lines should be <= 50 characters long",
      links: [],
      object: { confidence: "2" },
      git_blame_info: nil
    },
    {
      id: "whitespace/line_length",
      path: "test.cpp",
      location: { start_line: 2 },
      message: "Lines should be <= 50 characters long",
      links: [],
      object: { confidence: "2" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "cpplint", version: default_version }
)

s.add_test(
  "option_target",
  type: "success",
  issues: [
    {
      id: "whitespace/braces",
      path: "src/foo.cpp",
      location: { start_line: 2 },
      message: "Missing space before {",
      links: [],
      object: { confidence: "5" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "cpplint", version: default_version }
)

s.add_test(
  "option_target_multi",
  type: "success",
  issues: [
    {
      id: "whitespace/braces",
      path: "lib/bar.cc",
      location: { start_line: 2 },
      message: "Missing space before {",
      links: [],
      object: { confidence: "5" },
      git_blame_info: nil
    },
    {
      id: "whitespace/braces",
      path: "src/foo.cpp",
      location: { start_line: 2 },
      message: "Missing space before {",
      links: [],
      object: { confidence: "5" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "cpplint", version: default_version }
)

s.add_test(
  "no_line_number",
  type: "success",
  issues: [
    {
      id: "build/header_guard",
      path: "foo.h",
      location: nil,
      message: /No #ifndef header guard found, suggested CPP variable is:/,
      links: [],
      object: { confidence: "5" },
      git_blame_info: nil
    },
    {
      id: "build/include",
      path: "foo.cc",
      location: nil,
      message: /(.+)foo\.cc should include its header file (.+)foo\.h/,
      links: [],
      object: { confidence: "5" },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "cpplint", version: default_version }
)
