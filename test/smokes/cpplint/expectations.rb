Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "default",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        id: "legal/copyright",
        path: "src/test.cpp",
        location: nil,
        message: "No copyright message found.  You should have a line: \"Copyright [year] <Copyright Owner>\"",
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
    analyzer: { name: "cpplint", version: "1.4.5" }
  }
)

Smoke.add_test(
  "official_samples",
  { guid: "test-guid", timestamp: :_, type: "success", issues: :_, analyzer: { name: "cpplint", version: "1.4.5" } }
)

Smoke.add_test(
  "option_exclude",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "cpplint", version: "1.4.5" } }
)

Smoke.add_test(
  "option_exclude_multi",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "cpplint", version: "1.4.5" } }
)

Smoke.add_test(
  "option_extensions",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "cpplint", version: "1.4.5" } }
)

Smoke.add_test(
  "option_filter",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "cpplint", version: "1.4.5" }
  }
)

Smoke.add_test(
  "option_headers",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "cpplint", version: "1.4.5" } }
)

Smoke.add_test(
  "option_linelength",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "cpplint", version: "1.4.5" }
  }
)

Smoke.add_test(
  "option_target",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "cpplint", version: "1.4.5" }
  }
)

Smoke.add_test(
  "option_target_multi",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "cpplint", version: "1.4.5" }
  }
)

Smoke.add_test(
  "no_line_number",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "cpplint", version: "1.4.5" }
  }
)
