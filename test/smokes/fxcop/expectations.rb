s = Runners::Testing::Smoke

default_version = "3.3.1"

# a normal case
s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "Program.cs",
      location: { start_line: 7, start_column: 35, end_line: 7, end_column: 39 },
      id: "CA1801",
      message: "Parameter args of method Main is never used. Remove the parameter or use it in the method body.",
      object: {
        category: "Usage",
        description:
          "Avoid unused paramereters in your code. If the parameter cannot be removed, then change its name so it starts with an underscore and is optionally followed by an integer, such as '_', '_1', '_2', etc. These are treated as special discard symbol names.",
        severity: "Warning"
      },
      links: %w[https://docs.microsoft.com/dotnet/fundamentals/code-analysis/quality-rules/ca1801],
      git_blame_info: {
        commit: :_, line_hash: "e7002f7dd06c31a9f25368e012845661d00f49d9", original_line: 7, final_line: 7
      }
    },
    {
      path: "bar/Hello.cs",
      location: { start_line: 7, start_column: 41, end_line: 7, end_column: 45 },
      id: "CA1801",
      message: "Parameter text of method Print is never used. Remove the parameter or use it in the method body.",
      object: {
        category: "Usage",
        description:
          "Avoid unused paramereters in your code. If the parameter cannot be removed, then change its name so it starts with an underscore and is optionally followed by an integer, such as '_', '_1', '_2', etc. These are treated as special discard symbol names.",
        severity: "Warning"
      },
      links: %w[https://docs.microsoft.com/dotnet/fundamentals/code-analysis/quality-rules/ca1801],
      git_blame_info: {
        commit: :_, line_hash: "6c0131f10a46e93aebd78110e9f82f88708279c1", original_line: 7, final_line: 7
      }
    },
    {
      path: "Program.cs",
      location: { start_line: 5, start_column: 11, end_line: 5, end_column: 18 },
      id: "CA1812",
      message:
        "Program is an internal class that is apparently never instantiated. If so, remove the code from the assembly. If this class is intended to contain only static members, make it static (Shared in Visual Basic).",
      object: {
        category: "Performance",
        description: "An instance of an assembly-level type is not created by code in the assembly.",
        severity: "Warning"
      },
      links: %w[https://docs.microsoft.com/dotnet/fundamentals/code-analysis/quality-rules/ca1812],
      git_blame_info: {
        commit: :_, line_hash: "0a0c4509d7b357152d5ad499da7c652c97f3cb2c", original_line: 5, final_line: 5
      }
    }
  ],
  analyzer: { name: "FxCop", version: default_version }
)

# a project have .csproj file in non analysis root
s.add_test(
  "success_csproj_in_non_root_dir",
  type: "success",
  issues: [
    {
      path: "src/Program.cs",
      location: { start_line: 7, start_column: 35, end_line: 7, end_column: 39 },
      id: "CA1801",
      message: "Parameter args of method Main is never used. Remove the parameter or use it in the method body.",
      object: {
        category: "Usage",
        description:
          "Avoid unused paramereters in your code. If the parameter cannot be removed, then change its name so it starts with an underscore and is optionally followed by an integer, such as '_', '_1', '_2', etc. These are treated as special discard symbol names.",
        severity: "Warning"
      },
      links: %w[https://docs.microsoft.com/dotnet/fundamentals/code-analysis/quality-rules/ca1801],
      git_blame_info: {
        commit: :_, line_hash: "e7002f7dd06c31a9f25368e012845661d00f49d9", original_line: 7, final_line: 7
      }
    },
    {
      path: "src/bar/Hello.cs",
      location: { start_line: 7, start_column: 41, end_line: 7, end_column: 45 },
      id: "CA1801",
      message: "Parameter text of method Print is never used. Remove the parameter or use it in the method body.",
      object: {
        category: "Usage",
        description:
          "Avoid unused paramereters in your code. If the parameter cannot be removed, then change its name so it starts with an underscore and is optionally followed by an integer, such as '_', '_1', '_2', etc. These are treated as special discard symbol names.",
        severity: "Warning"
      },
      links: %w[https://docs.microsoft.com/dotnet/fundamentals/code-analysis/quality-rules/ca1801],
      git_blame_info: {
        commit: :_, line_hash: "6c0131f10a46e93aebd78110e9f82f88708279c1", original_line: 7, final_line: 7
      }
    },
    {
      path: "src/Program.cs",
      location: { start_line: 5, start_column: 11, end_line: 5, end_column: 18 },
      id: "CA1812",
      message:
        "Program is an internal class that is apparently never instantiated. If so, remove the code from the assembly. If this class is intended to contain only static members, make it static (Shared in Visual Basic).",
      object: {
        category: "Performance",
        description: "An instance of an assembly-level type is not created by code in the assembly.",
        severity: "Warning"
      },
      links: %w[https://docs.microsoft.com/dotnet/fundamentals/code-analysis/quality-rules/ca1812],
      git_blame_info: {
        commit: :_, line_hash: "0a0c4509d7b357152d5ad499da7c652c97f3cb2c", original_line: 5, final_line: 5
      }
    }
  ],
  analyzer: { name: "FxCop", version: default_version }
)
