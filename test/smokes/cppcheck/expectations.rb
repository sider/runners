s = Runners::Testing::Smoke

default_version = "2.1"

s.add_test(
  "default",
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      path: "arrayIndexOutOfBounds.c",
      location: { start_line: 7, start_column: 6 },
      message: "Array 'a[2]' accessed at index 2, which is out of bounds.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "788", location_info: "Array index out of bounds"
      },
      git_blame_info: {
        commit: :_, line_hash: "0385494c4c5930cf676a075a1eff5644b391b1c8", original_line: 7, final_line: 7
      }
    },
    {
      id: "autoVariables",
      path: "autoVariables.c",
      location: { start_line: 4, start_column: 5 },
      message: "Address of local auto-variable assigned to a function parameter.",
      links: [],
      object: {
        severity: "error",
        verbose: /Dangerous assignment - the function parameter is assigned the address of a local auto-variable/,
        inconclusive: false,
        cwe: "562",
        location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "269223283dca9ded34559b2b1186e36a49dd13d3", original_line: 4, final_line: 4
      }
    },
    {
      id: "ctunullpointer",
      path: "src/nullpointer.c",
      location: { start_line: 2, start_column: 6 },
      message: "Null pointer dereference: q",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "476", location_info: "Dereferencing argument q that is null"
      },
      git_blame_info: {
        commit: :_, line_hash: "18737ae19d9ba677cc75212276757fefbeff2d5a", original_line: 2, final_line: 2
      }
    },
    {
      id: "ctunullpointer",
      path: "src/nullpointer.c",
      location: { start_line: 6, start_column: 14 },
      message: "Null pointer dereference: q",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "476", location_info: "Assignment 'a=0', assigned value is 0"
      },
      git_blame_info: {
        commit: :_, line_hash: "3fa4dc7d4e6657a293c827b3e374636b3ccea575", original_line: 6, final_line: 6
      }
    },
    {
      id: "ctunullpointer",
      path: "src/nullpointer.c",
      location: { start_line: 7, start_column: 6 },
      message: "Null pointer dereference: q",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "476", location_info: "Calling function f, 1st argument is null"
      },
      git_blame_info: {
        commit: :_, line_hash: "26d62c425999f29ac2a500ca5913cd47d409d642", original_line: 7, final_line: 7
      }
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 4, start_column: 22 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "664", location_info: "Variable created here."
      },
      git_blame_info: {
        commit: :_, line_hash: "d3c98fa5178f3d1dd69beb39759e9fc9ebfdf022", original_line: 4, final_line: 4
      }
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 9, start_column: 17 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "664", location_info: "Iterator to container is created here."
      },
      git_blame_info: {
        commit: :_, line_hash: "7dba3f7f5bfd78af77fe0c7b16a07ab724ac35c0", original_line: 9, final_line: 9
      }
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 9, start_column: 32 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "664", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "7dba3f7f5bfd78af77fe0c7b16a07ab724ac35c0", original_line: 9, final_line: 9
      }
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 9, start_column: 37 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "664", location_info: "Assuming condition is true."
      },
      git_blame_info: {
        commit: :_, line_hash: "7dba3f7f5bfd78af77fe0c7b16a07ab724ac35c0", original_line: 9, final_line: 9
      }
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 10, start_column: 19 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "664", location_info: "Assuming condition is true."
      },
      git_blame_info: {
        commit: :_, line_hash: "764b27058cb69d6367ba465080d093d77c7d6328", original_line: 10, final_line: 10
      }
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 10, start_column: 19 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "664", location_info: "Assuming condition is true."
      },
      git_blame_info: {
        commit: :_, line_hash: "764b27058cb69d6367ba465080d093d77c7d6328", original_line: 10, final_line: 10
      }
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 11, start_column: 13 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "664", location_info: "After calling 'erase', iterators or references to the container's data may be invalid ."
      },
      git_blame_info: {
        commit: :_, line_hash: "e477236326c17205d7fb978de73d214146e7a161", original_line: 11, final_line: 11
      }
    },
    {
      id: "nullPointer",
      path: "src/nullpointer.c",
      location: { start_line: 2, start_column: 6 },
      message: "Possible null pointer dereference: q",
      links: [],
      object: {
        severity: "warning", verbose: nil, inconclusive: false, cwe: "476", location_info: "Null pointer dereference"
      },
      git_blame_info: {
        commit: :_, line_hash: "18737ae19d9ba677cc75212276757fefbeff2d5a", original_line: 2, final_line: 2
      }
    },
    {
      id: "nullPointer",
      path: "src/nullpointer.c",
      location: { start_line: 6, start_column: 14 },
      message: "Possible null pointer dereference: q",
      links: [],
      object: {
        severity: "warning", verbose: nil, inconclusive: false, cwe: "476", location_info: "Assignment 'a=0', assigned value is 0"
      },
      git_blame_info: {
        commit: :_, line_hash: "3fa4dc7d4e6657a293c827b3e374636b3ccea575", original_line: 6, final_line: 6
      }
    },
    {
      id: "nullPointer",
      path: "src/nullpointer.c",
      location: { start_line: 7, start_column: 7 },
      message: "Possible null pointer dereference: q",
      links: [],
      object: {
        severity: "warning", verbose: nil, inconclusive: false, cwe: "476",       location_info: "Calling function 'f', 1st argument 'a' value is 0"
      },
      git_blame_info: {
        commit: :_, line_hash: "26d62c425999f29ac2a500ca5913cd47d409d642", original_line: 7, final_line: 7
      }
    },
    {
      id: "syntaxError",
      path: "src/syntaxError.c",
      location: { start_line: 2, start_column: 1 },
      message: "Unmatched '{'. Configuration: ''.",
      links: [],
      object: { severity: "error", verbose: nil, inconclusive: false, cwe: nil, location_info: nil },
      git_blame_info: {
        commit: :_, line_hash: "60ba4b2daa4ed4d070fec06687e249e0e6f9ee45", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "no_target",
  type: "success",
  issues: [],
  analyzer: { name: "Cppcheck", version: default_version },
  warnings: [{ message: "No linting files.", file: nil }]
)

s.add_test(
  "single_target",
  type: "success",
  issues: [
    {
      id: "autoVariables",
      path: "autoVariables.c",
      location: { start_line: 4, start_column: 5 },
      message: "Address of local auto-variable assigned to a function parameter.",
      links: [],
      object: {
        severity: "error", verbose: /Dangerous assignment -/, inconclusive: false, cwe: "562", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "269223283dca9ded34559b2b1186e36a49dd13d3", original_line: 4, final_line: 4
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "multiple_target",
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      path: "src/arrayIndexOutOfBounds.c",
      location: { start_line: 7, start_column: 6 },
      message: "Array 'a[2]' accessed at index 2, which is out of bounds.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "788", location_info: "Array index out of bounds"
      },
      git_blame_info: {
        commit: :_, line_hash: "0385494c4c5930cf676a075a1eff5644b391b1c8", original_line: 7, final_line: 7
      }
    },
    {
      id: "autoVariables",
      path: "autoVariables.c",
      location: { start_line: 4, start_column: 5 },
      message: "Address of local auto-variable assigned to a function parameter.",
      links: [],
      object: {
        severity: "error", verbose: /Dangerous assignment -/, inconclusive: false, cwe: "562", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "269223283dca9ded34559b2b1186e36a49dd13d3", original_line: 4, final_line: 4
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "single_ignore",
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      path: "arrayIndexOutOfBounds.c",
      location: { start_line: 7, start_column: 6 },
      message: "Array 'a[2]' accessed at index 2, which is out of bounds.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "788", location_info: "Array index out of bounds"
      },
      git_blame_info: {
        commit: :_, line_hash: "0385494c4c5930cf676a075a1eff5644b391b1c8", original_line: 7, final_line: 7
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "multiple_ignore",
  type: "success",
  issues: [
    {
      id: "syntaxError",
      path: "syntaxError.c",
      location: { start_line: 2, start_column: 1 },
      message: "Unmatched '{'. Configuration: ''.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "60ba4b2daa4ed4d070fec06687e249e0e6f9ee45", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "enable",
  type: "success",
  issues: [
    {
      id: "readWriteOnlyFile",
      path: "bad.c",
      location: { start_line: 5, start_column: 5 },
      message: "Read operation on a file that was opened only for writing.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "664", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "479ce88b23ce551981eed443165ea6a466a3e7e2", original_line: 5, final_line: 5
      }
    },
    {
      id: "seekOnAppendedFile",
      path: "bad.c",
      location: { start_line: 4, start_column: 5 },
      message: "Repositioning operation performed on a file opened in append mode has no effect.",
      links: [],
      object: {
        severity: "warning", verbose: nil, inconclusive: false, cwe: "398", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "90556cd318a1aaf1aa004d2b6c37189d79f5d3a0", original_line: 4, final_line: 4
      }
    },
    {
      id: "unusedFunction",
      path: "bad.c",
      location: { start_line: 1, start_column: 0 },
      message: "The function 'foo' is never used.",
      links: [],
      object: {
        severity: "style", verbose: nil, inconclusive: false, cwe: "561", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "aba21ca7df06967d62bb367398a9d2f826c398f9", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "parallel",
  type: "success",
  issues: [
    {
      id: "readWriteOnlyFile",
      path: "bad.c",
      location: { start_line: 5, start_column: 5 },
      message: "Read operation on a file that was opened only for writing.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "664", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "479ce88b23ce551981eed443165ea6a466a3e7e2", original_line: 5, final_line: 5
      }
    },
    {
      id: "seekOnAppendedFile",
      path: "bad.c",
      location: { start_line: 4, start_column: 5 },
      message: "Repositioning operation performed on a file opened in append mode has no effect.",
      links: [],
      object: {
        severity: "warning", verbose: nil, inconclusive: false, cwe: "398", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "90556cd318a1aaf1aa004d2b6c37189d79f5d3a0", original_line: 4, final_line: 4
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "std",
  type: "success",
  issues: [
    {
      id: "allocaCalled",
      path: "bad.c",
      location: { start_line: 2, start_column: 15 },
      message:
        "Obsolete function 'alloca' called. In C99 and later it is recommended to use a variable length array instead.",
      links: [],
      object: {
        severity: "warning", verbose: /The obsolete function 'alloca' is called./, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "8ea8779fe0e7ba0a880baa957d3db74f8820acc4", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "project",
  type: "success",
  issues: [
    {
      id: "zerodiv",
      path: "main.c",
      location: { start_line: 5, start_column: 11 },
      message: "Division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: "Division by zero"
      },
      git_blame_info: {
        commit: :_, line_hash: "81218339ebcce72e9ff0b2d8302aafd44a872f40", original_line: 5, final_line: 5
      }
    }
  ],
  warnings: [{ message: <<~MSG.strip, file: "sider.yml" }],
    The `parallel` option is ignored when the `project` option is specified.
    This limitation is due to the behavior of Cppcheck.
  MSG
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "language",
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      path: "bad.c",
      location: { start_line: 4, start_column: 6 },
      message: "Array 'a[1]' accessed at index 1, which is out of bounds.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "788", location_info: "Array index out of bounds"
      },
      git_blame_info: {
        commit: :_, line_hash: "5f508f44c9a9245f3fa917111ae85e321c53b572", original_line: 4, final_line: 4
      }
    },
    {
      id: "syntaxError",
      path: "bad.cpp",
      location: { start_line: 4, start_column: 5 },
      message: "Code 'std::vector' is invalid C code. Use --std or --language to configure the language.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d3c98fa5178f3d1dd69beb39759e9fc9ebfdf022", original_line: 4, final_line: 4
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "unexpected_error",
  type: "failure",
  message: "The analysis failed due to an unexpected error. See the analysis log for details.",
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "addon",
  type: "success",
  issues: [
    {
      id: "misra-c2012-14.4",
      path: "bad.c",
      location: { start_line: 8, start_column: 7 },
      message: "misra violation (use --rule-texts=<file> to get proper output)",
      links: [],
      object: {
        severity: "style", verbose: nil, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "52c47a444042d82bb3c72e55e9947be2de040e53", original_line: 8, final_line: 8
      }
    },
    {
      id: "misra-c2012-21.1",
      path: "bad.h",
      location: { start_line: 2, start_column: 0 },
      message: "misra violation (use --rule-texts=<file> to get proper output)",
      links: [],
      object: {
        severity: "style", verbose: nil, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "2680ff859efce882776fc741b04adaa2836d9620", original_line: 2, final_line: 2
      }
    },
    {
      id: "y2038-type-bits-undef",
      path: "bad.h",
      location: { start_line: 2, start_column: 0 },
      message: "_USE_TIME_BITS64 is defined but _TIME_BITS was not",
      links: [],
      object: {
        severity: "warning", verbose: nil, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "2680ff859efce882776fc741b04adaa2836d9620", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "addon_misra_rules",
  type: "success",
  issues: [
    {
      id: "misra-c2012-12.3",
      path: "src/foo/test.cpp",
      location: { start_line: 9, start_column: 8 },
      message: "Text of rule 12.3",
      links: [],
      object: {
        severity: "style", verbose: nil, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "176c8a3b6a09d7b345b7195ec5c7bda7217c54fd", original_line: 9, final_line: 9
      }
    },
    {
      id: "misra-c2012-14.4",
      path: "src/foo/test.cpp",
      location: { start_line: 16, start_column: 11 },
      message: "Text of rule 14.4",
      links: [],
      object: {
        severity: "style", verbose: nil, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "35cb9ab29b3b00e0178c1cedd28e3ff9e26a774b", original_line: 16, final_line: 16
      }
    },
    {
      id: "misra-c2012-16.4",
      path: "src/foo/test.cpp",
      location: { start_line: 10, start_column: 3 },
      message: "Text of rule 16.4",
      links: [],
      object: {
        severity: "style", verbose: nil, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "8b69aac82f9b73e5c5bf05158f2556fda91e6d0b", original_line: 10, final_line: 10
      }
    },
    {
      id: "misra-c2012-21.6",
      path: "src/foo/test.cpp",
      location: { start_line: 2, start_column: 0 },
      message: "Text of rule 21.6",
      links: [],
      object: {
        severity: "style", verbose: nil, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d42248803e602b7ee4448ae8d372f0f95421205f", original_line: 2, final_line: 2
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "bug_hunting_target",
  type: "success",
  issues: [
    {
      id: "bughuntingDivByZero",
      path: "src/bar/cpp_sample.c++",
      location: { start_line: 11, start_column: 15 },
      message: "There is division, cannot determine that there can't be a division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "74cc2eab823e61f73b1c85432ea4ecca95512c49", original_line: 11, final_line: 11
      }
    },
    {
      id: "bughuntingDivByZero",
      path: "src/cpp_sample_2.c++",
      location: { start_line: 9, start_column: 15 },
      message: "There is division, cannot determine that there can't be a division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "74cc2eab823e61f73b1c85432ea4ecca95512c49", original_line: 9, final_line: 9
      }
    },
    {
      id: "bughuntingDivByZeroFloat",
      path: "src/bar/c_sample.c",
      location: { start_line: 18, start_column: 14 },
      message: "There is division, cannot determine that there can't be a division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "fe526b59f18512f140fb71bea18d10db1d4b0c61", original_line: 18, final_line: 18
      }
    },
    {
      id: "bughuntingDivByZeroFloat",
      path: "src/bar/c_sample.c",
      location: { start_line: 20, start_column: 14 },
      message: "There is division, cannot determine that there can't be a division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "892a43a4ab9cc0b9146f738d98773094107490be", original_line: 20, final_line: 20
      }
    },
    {
      id: "bughuntingDivByZeroFloat",
      path: "src/bar/cpp_sample.c++",
      location: { start_line: 24, start_column: 14 },
      message: "There is division, cannot determine that there can't be a division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "fe526b59f18512f140fb71bea18d10db1d4b0c61", original_line: 24, final_line: 24
      }
    },
    {
      id: "bughuntingDivByZeroFloat",
      path: "src/cpp_sample_2.c++",
      location: { start_line: 22, start_column: 14 },
      message: "There is division, cannot determine that there can't be a division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "fe526b59f18512f140fb71bea18d10db1d4b0c61", original_line: 22, final_line: 22
      }
    },
    {
      id: "bughuntingUninit",
      path: "src/bar/c_sample.c",
      location: { start_line: 16, start_column: 12 },
      message: "Cannot determine that 'dz' is initialized",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 16, final_line: 16
      }
    },
    {
      id: "bughuntingUninit",
      path: "src/bar/c_sample.c",
      location: { start_line: 19, start_column: 16 },
      message: "Cannot determine that 'dz' is initialized",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "acf5ddfa8e7109366a023a35caed04623817c40d", original_line: 19, final_line: 19
      }
    },
    {
      id: "bughuntingUninit",
      path: "src/bar/cpp_sample.c++",
      location: { start_line: 22, start_column: 12 },
      message: "Cannot determine that 'dz' is initialized",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 22, final_line: 22
      }
    },
    {
      id: "bughuntingUninit",
      path: "src/bar/cpp_sample.c++",
      location: { start_line: 25, start_column: 16 },
      message: "Cannot determine that 'dz' is initialized",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "acf5ddfa8e7109366a023a35caed04623817c40d", original_line: 25, final_line: 25
      }
    },
    {
      id: "bughuntingUninit",
      path: "src/cpp_sample_2.c++",
      location: { start_line: 20, start_column: 12 },
      message: "Cannot determine that 'dz' is initialized",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 20, final_line: 20
      }
    },
    {
      id: "bughuntingUninit",
      path: "src/cpp_sample_2.c++",
      location: { start_line: 23, start_column: 16 },
      message: "Cannot determine that 'dz' is initialized",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "acf5ddfa8e7109366a023a35caed04623817c40d", original_line: 23, final_line: 23
      }
    },
    {
      id: "uninitvar",
      path: "src/bar/c_sample.c",
      location: { start_line: 16, start_column: 12 },
      message: "Uninitialized variable: dz",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 16, final_line: 16
      }
    },
    {
      id: "uninitvar",
      path: "src/bar/c_sample.c",
      location: { start_line: 19, start_column: 16 },
      message: "Uninitialized variable: dz",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "acf5ddfa8e7109366a023a35caed04623817c40d", original_line: 19, final_line: 19
      }
    },
    {
      id: "uninitvar",
      path: "src/bar/cpp_sample.c++",
      location: { start_line: 22, start_column: 12 },
      message: "Uninitialized variable: dz",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 22, final_line: 22
      }
    },
    {
      id: "uninitvar",
      path: "src/bar/cpp_sample.c++",
      location: { start_line: 25, start_column: 16 },
      message: "Uninitialized variable: dz",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "acf5ddfa8e7109366a023a35caed04623817c40d", original_line: 25, final_line: 25
      }
    },
    {
      id: "uninitvar",
      path: "src/cpp_sample_2.c++",
      location: { start_line: 20, start_column: 12 },
      message: "Uninitialized variable: dz",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 20, final_line: 20
      }
    },
    {
      id: "uninitvar",
      path: "src/cpp_sample_2.c++",
      location: { start_line: 23, start_column: 16 },
      message: "Uninitialized variable: dz",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "acf5ddfa8e7109366a023a35caed04623817c40d", original_line: 23, final_line: 23
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "bug_hunting_project",
  type: "success",
  issues: [
    {
      id: "bughuntingDivByZero",
      path: "src/cpp_sample_1.c++",
      location: { start_line: 7, start_column: 15 },
      message: "There is division, cannot determine that there can't be a division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "74cc2eab823e61f73b1c85432ea4ecca95512c49", original_line: 7, final_line: 7
      }
    },
    {
      id: "bughuntingDivByZero",
      path: "src/cpp_sample_3.c++",
      location: { start_line: 11, start_column: 15 },
      message: "There is division, cannot determine that there can't be a division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "74cc2eab823e61f73b1c85432ea4ecca95512c49", original_line: 11, final_line: 11
      }
    },
    {
      id: "bughuntingDivByZeroFloat",
      path: "src/cpp_sample_1.c++",
      location: { start_line: 20, start_column: 14 },
      message: "There is division, cannot determine that there can't be a division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "fe526b59f18512f140fb71bea18d10db1d4b0c61", original_line: 20, final_line: 20
      }
    },
    {
      id: "bughuntingDivByZeroFloat",
      path: "src/cpp_sample_3.c++",
      location: { start_line: 24, start_column: 14 },
      message: "There is division, cannot determine that there can't be a division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "fe526b59f18512f140fb71bea18d10db1d4b0c61", original_line: 24, final_line: 24
      }
    },
    {
      id: "bughuntingUninit",
      path: "src/cpp_sample_1.c++",
      location: { start_line: 18, start_column: 12 },
      message: "Cannot determine that 'dz' is initialized",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 18, final_line: 18
      }
    },
    {
      id: "bughuntingUninit",
      path: "src/cpp_sample_1.c++",
      location: { start_line: 21, start_column: 16 },
      message: "Cannot determine that 'dz' is initialized",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "acf5ddfa8e7109366a023a35caed04623817c40d", original_line: 21, final_line: 21
      }
    },
    {
      id: "bughuntingUninit",
      path: "src/cpp_sample_3.c++",
      location: { start_line: 22, start_column: 12 },
      message: "Cannot determine that 'dz' is initialized",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 22, final_line: 22
      }
    },
    {
      id: "bughuntingUninit",
      path: "src/cpp_sample_3.c++",
      location: { start_line: 25, start_column: 16 },
      message: "Cannot determine that 'dz' is initialized",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "acf5ddfa8e7109366a023a35caed04623817c40d", original_line: 25, final_line: 25
      }
    },
    {
      id: "uninitvar",
      path: "src/cpp_sample_1.c++",
      location: { start_line: 18, start_column: 12 },
      message: "Uninitialized variable: dz",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 18, final_line: 18
      }
    },
    {
      id: "uninitvar",
      path: "src/cpp_sample_1.c++",
      location: { start_line: 21, start_column: 16 },
      message: "Uninitialized variable: dz",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "acf5ddfa8e7109366a023a35caed04623817c40d", original_line: 21, final_line: 21
      }
    },
    {
      id: "uninitvar",
      path: "src/cpp_sample_3.c++",
      location: { start_line: 22, start_column: 12 },
      message: "Uninitialized variable: dz",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 22, final_line: 22
      }
    },
    {
      id: "uninitvar",
      path: "src/cpp_sample_3.c++",
      location: { start_line: 25, start_column: 16 },
      message: "Uninitialized variable: dz",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "acf5ddfa8e7109366a023a35caed04623817c40d", original_line: 25, final_line: 25
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "bug_hunting_addon",
  type: "success",
  issues: [
    {
      id: "bughuntingDivByZeroFloat",
      path: "c_sample.c",
      location: { start_line: 12, start_column: 14 },
      message: "There is division, cannot determine that there can't be a division by zero.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "369", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "fe526b59f18512f140fb71bea18d10db1d4b0c61", original_line: 12, final_line: 12
      }
    },
    {
      id: "bughuntingUninit",
      path: "c_sample.c",
      location: { start_line: 10, start_column: 12 },
      message: "Cannot determine that 'dz' is initialized",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 10, final_line: 10
      }
    },
    {
      id: "misra-c2012-10.4",
      path: "c_sample.c",
      location: { start_line: 12, start_column: 14 },
      message: "misra violation (use --rule-texts=<file> to get proper output)",
      links: [],
      object: {
        severity: "style", verbose: nil, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "fe526b59f18512f140fb71bea18d10db1d4b0c61", original_line: 12, final_line: 12
      }
    },
    {
      id: "misra-c2012-12.3",
      path: "c_sample.c",
      location: { start_line: 5, start_column: 14 },
      message: "misra violation (use --rule-texts=<file> to get proper output)",
      links: [],
      object: {
        severity: "style", verbose: nil, inconclusive: false, cwe: nil, location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "ee4325a254e6006d8385abf71cabf88046b3e531", original_line: 5, final_line: 5
      }
    },
    {
      id: "uninitvar",
      path: "c_sample.c",
      location: { start_line: 10, start_column: 12 },
      message: "Uninitialized variable: dz",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "457", location_info: nil
      },
      git_blame_info: {
        commit: :_, line_hash: "d1dc81b8c917189f68cc5bec2965b205d13162d5", original_line: 10, final_line: 10
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "include_path",
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      path: "source/test.c++",
      location: { start_line: 9, start_column: 7 },
      message: "Array 'buf3[33]' accessed at index 33, which is out of bounds.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "788", location_info: "Array index out of bounds"
      },
      git_blame_info: {
        commit: :_, line_hash: "5efffb814135304ded82fc54507a923820527764", original_line: 9, final_line: 9
      }
    },
    {
      id: "arrayIndexOutOfBounds",
      path: "source/サンプル/test.CPP",
      location: { start_line: 10, start_column: 6 },
      message: "Array 'buf[21]' accessed at index 21, which is out of bounds.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "788", location_info: "Array index out of bounds"
      },
      git_blame_info: {
        commit: :_, line_hash: "c54a96ab932a5b6272b9ce8d62d62343672e90f5", original_line: 10, final_line: 10
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "include_path_default",
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      path: "source/foo/テスト.cxx",
      location: { start_line: 8, start_column: 8 },
      message: "Array 'buf[25]' accessed at index 25, which is out of bounds.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "788", location_info: "Array index out of bounds"
      },
      git_blame_info: {
        commit: :_, line_hash: "0299a8be0af51ec676f3c30e694e0229831f126f", original_line: 8, final_line: 8
      }
    },
    {
      id: "arrayIndexOutOfBounds",
      path: "source/test.c",
      location: { start_line: 10, start_column: 6 },
      message: "Array 'buf[17]' accessed at index 17, which is out of bounds.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "788", location_info: "Array index out of bounds"
      },
      git_blame_info: {
        commit: :_, line_hash: "d7b8c5f1ee3ed706b98346c0474e7efe9924351a", original_line: 10, final_line: 10
      }
    },
    {
      id: "arrayIndexOutOfBounds",
      path: "source/xuq/test.CC",
      location: { start_line: 9, start_column: 4 },
      message: "Array 's[25]' accessed at index 25, which is out of bounds.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "788", location_info: "Array index out of bounds"
      },
      git_blame_info: {
        commit: :_, line_hash: "e7fa5e00a4eeb5a38b74c5674e8036d67751508a", original_line: 9, final_line: 9
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)

s.add_test(
  "config_string_values",
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      path: "src/test.c",
      location: { start_line: 9, start_column: 6 },
      message: "Array 'buf[31]' accessed at index 31, which is out of bounds.",
      links: [],
      object: {
        severity: "error", verbose: nil, inconclusive: false, cwe: "788", location_info: "Array index out of bounds"
      },
      git_blame_info: {
        commit: :_, line_hash: "d170f5327fbab43247efa9e0283e882d7efbb141", original_line: 9, final_line: 9
      }
    }
  ],
  analyzer: { name: "Cppcheck", version: default_version }
)
