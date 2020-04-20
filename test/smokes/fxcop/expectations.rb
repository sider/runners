Smoke = Runners::Testing::Smoke

ANALYZER = { name: 'FxCop', version: '2.9.8' }.freeze

ISSUES_PROGRAM_CS = [
  {
    path: 'Program.cs',
    location: { start_line: 7, start_column: 35, end_line: 7, end_column: 39 },
    id: "CA1801",
    message: "Parameter args of method Main is never used. Remove the parameter or use it in the method body.",
    object: {
      category: "Usage",
      description: "Avoid unused paramereters in your code. If the parameter cannot be removed, then change its name so it starts with an underscore and is optionally followed by an integer, such as '_', '_1', '_2', etc. These are treated as special discard symbol names.",
      severity: 2,
    },
    git_blame_info: nil,
    links: ["https://docs.microsoft.com/visualstudio/code-quality/ca1801-review-unused-parameters"]
  },
  {
    path: 'bar/Hello.cs',
    location: { start_line: 7, start_column: 41, end_line: 7, end_column: 45 },
    id: "CA1801",
    message: "Parameter text of method Print is never used. Remove the parameter or use it in the method body.",
    object: {
      category: "Usage",
      description: "Avoid unused paramereters in your code. If the parameter cannot be removed, then change its name so it starts with an underscore and is optionally followed by an integer, such as '_', '_1', '_2', etc. These are treated as special discard symbol names.",
      severity: 2,
    },
    git_blame_info: nil,
    links: ["https://docs.microsoft.com/visualstudio/code-quality/ca1801-review-unused-parameters"]
  },
  {
    path: 'Program.cs',
    location: { start_line: 5, start_column: 11, end_line: 5, end_column: 18 },
    id: "CA1812",
    message: "Program is an internal class that is apparently never instantiated. If so, remove the code from the assembly. If this class is intended to contain only static members, make it static (Shared in Visual Basic).",
    object: {
      category: "Performance",
      description: "An instance of an assembly-level type is not created by code in the assembly.",
      severity: 2,
    },
    git_blame_info: nil,
    links: ["https://docs.microsoft.com/visualstudio/code-quality/ca1812-avoid-uninstantiated-internal-classes"]
  },
].freeze

# a normal case
Smoke.add_test(
  'success',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: [
      {
        path: 'Program.cs',
        location: { start_line: 7, start_column: 35, end_line: 7, end_column: 39 },
        id: "CA1801",
        message: "Parameter args of method Main is never used. Remove the parameter or use it in the method body.",
        object: {
          category: "Usage",
          description: "Avoid unused paramereters in your code. If the parameter cannot be removed, then change its name so it starts with an underscore and is optionally followed by an integer, such as '_', '_1', '_2', etc. These are treated as special discard symbol names.",
          severity: 2,
        },
        git_blame_info: nil,
        links: ["https://docs.microsoft.com/visualstudio/code-quality/ca1801-review-unused-parameters"]
      },
      {
        path: 'bar/Hello.cs',
        location: { start_line: 7, start_column: 41, end_line: 7, end_column: 45 },
        id: "CA1801",
        message: "Parameter text of method Print is never used. Remove the parameter or use it in the method body.",
        object: {
          category: "Usage",
          description: "Avoid unused paramereters in your code. If the parameter cannot be removed, then change its name so it starts with an underscore and is optionally followed by an integer, such as '_', '_1', '_2', etc. These are treated as special discard symbol names.",
          severity: 2,
        },
        git_blame_info: nil,
        links: ["https://docs.microsoft.com/visualstudio/code-quality/ca1801-review-unused-parameters"]
      },
      {
        path: 'Program.cs',
        location: { start_line: 5, start_column: 11, end_line: 5, end_column: 18 },
        id: "CA1812",
        message: "Program is an internal class that is apparently never instantiated. If so, remove the code from the assembly. If this class is intended to contain only static members, make it static (Shared in Visual Basic).",
        object: {
          category: "Performance",
          description: "An instance of an assembly-level type is not created by code in the assembly.",
          severity: 2,
        },
        git_blame_info: nil,
        links: ["https://docs.microsoft.com/visualstudio/code-quality/ca1812-avoid-uninstantiated-internal-classes"]
      },
    ],
    analyzer: { name: 'FxCop', version: '2.9.8' }
  }
)

# a normal case (the target repository already enable fxcop)
Smoke.add_test(
  'already_enable_fxcop',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: ISSUES_PROGRAM_CS,
    analyzer: ANALYZER
  }
)

# a normal case (the target repository already enable old fxcop)
Smoke.add_test(
  'already_enable_oldversion_fxcop',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: ISSUES_PROGRAM_CS,
    analyzer: ANALYZER
  }
)

# a project have .csproj file in non analysis root
Smoke.add_test(
  'success_csproj_in_non_root_dir',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: [
      {
        path: 'src/Program.cs',
        location: { start_line: 7, start_column: 35, end_line: 7, end_column: 39 },
        id: "CA1801",
        message: "Parameter args of method Main is never used. Remove the parameter or use it in the method body.",
        object: {
          category: "Usage",
          description: "Avoid unused paramereters in your code. If the parameter cannot be removed, then change its name so it starts with an underscore and is optionally followed by an integer, such as '_', '_1', '_2', etc. These are treated as special discard symbol names.",
          severity: 2,
        },
        git_blame_info: nil,
        links: ["https://docs.microsoft.com/visualstudio/code-quality/ca1801-review-unused-parameters"]
      },
      {
        path: 'src/bar/Hello.cs',
        location: { start_line: 7, start_column: 41, end_line: 7, end_column: 45 },
        id: "CA1801",
        message: "Parameter text of method Print is never used. Remove the parameter or use it in the method body.",
        object: {
          category: "Usage",
          description: "Avoid unused paramereters in your code. If the parameter cannot be removed, then change its name so it starts with an underscore and is optionally followed by an integer, such as '_', '_1', '_2', etc. These are treated as special discard symbol names.",
          severity: 2,
        },
        git_blame_info: nil,
        links: ["https://docs.microsoft.com/visualstudio/code-quality/ca1801-review-unused-parameters"]
      },
      {
        path: 'src/Program.cs',
        location: { start_line: 5, start_column: 11, end_line: 5, end_column: 18 },
        id: "CA1812",
        message: "Program is an internal class that is apparently never instantiated. If so, remove the code from the assembly. If this class is intended to contain only static members, make it static (Shared in Visual Basic).",
        object: {
          category: "Performance",
          description: "An instance of an assembly-level type is not created by code in the assembly.",
          severity: 2,
        },
        git_blame_info: nil,
        links: ["https://docs.microsoft.com/visualstudio/code-quality/ca1812-avoid-uninstantiated-internal-classes"]
      },
    ],
    analyzer: { name: 'FxCop', version: '2.9.8' }
  }
)

# a project don't have .NET Core Project file (csproj)
Smoke.add_test(
  'no_csproj',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: [
      {
        path: 'Program.cs',
        location: { start_line: 3, start_column: 11, end_line: 3, end_column: 20 },
        id: 'CA1707',
        message: 'Remove the underscores from namespace name \'no_csproj\'.',
        object: {
          category: "Naming",
          description: "By convention, identifier names do not contain the underscore (_) character. This rule checks namespaces, types, members, and parameters.",
          severity: 2,
        },
        git_blame_info: nil,
        links: ["https://docs.microsoft.com/visualstudio/code-quality/ca1707-identifiers-should-not-contain-underscores"]
      },
    ] + ISSUES_PROGRAM_CS,
    analyzer: ANALYZER
  }
)

# a project have invalid .NET Core Project file (csproj)
Smoke.add_test(
  'invalid_csproj',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: ISSUES_PROGRAM_CS,
    analyzer: ANALYZER
  }
)

# pass invalid command line argument to return error code
Smoke.add_test(
  'invalid_arg',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'error',
    class: "RuntimeError",
    backtrace: :_,
    inspect: "#<RuntimeError: Sider.RoslynAnalyzersRunner 0.1.2\nCopyright (C) 2020 Sider.RoslynAnalyzersRunner\n\nERROR(S):\n  Option 'dummy.cs' is unknown.\n\n  --language           (Default: CSharp)\n\n  --outputfile         (Default: -)\n\n  --help               Display this help screen.\n\n  --version            Display version information.\n\n  file ... (pos. 0)    \n\n>"
  }
)
