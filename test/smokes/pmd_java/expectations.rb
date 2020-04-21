s = Runners::Testing::Smoke

s.add_test(
  "success",
  type: "success",
  analyzer: { name: "PMD Java", version: "6.21.0" },
  issues: [
    {
      message: "Do not add empty strings",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_performance.html#addemptystring],
      id: "AddEmptyString",
      path: "src/Hello.java",
      location: { start_line: 17, start_column: 16, end_line: 17, end_column: 17 },
      object: { ruleset: "Performance", priority: "3" },
      git_blame_info: nil
    },
    {
      message: "Avoid calling finalize() explicitly",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_errorprone.html#avoidcallingfinalize],
      id: "AvoidCallingFinalize",
      path: "src/Hello.java",
      location: { start_line: 16, start_column: 9, end_line: 16, end_column: 16 },
      object: { ruleset: "Error Prone", priority: "3" },
      git_blame_info: nil
    },
    {
      message: "Use block level rather than method level synchronization",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_multithreading.html#avoidsynchronizedatmethodlevel],
      id: "AvoidSynchronizedAtMethodLevel",
      path: "src/Hello.java",
      location: { start_line: 20, start_column: 18, end_line: 20, end_column: 29 },
      object: { ruleset: "Multithreading", priority: "3" },
      git_blame_info: nil
    },
    {
      message: "Exceptions should not extend java.lang.Error",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_design.html#donotextendjavalangerror],
      id: "DoNotExtendJavaLangError",
      path: "src/Hello.java",
      location: { start_line: 22, start_column: 23, end_line: 22, end_column: 37 },
      object: { ruleset: "Design", priority: "3" },
      git_blame_info: nil
    },
    {
      message: "Do not use hard coded encryption keys",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_security.html#hardcodedcryptokey],
      id: "HardCodedCryptoKey",
      path: "src/Hello.java",
      location: { start_line: 12, start_column: 27, end_line: 12, end_column: 42 },
      object: { ruleset: "Security", priority: "3" },
      git_blame_info: nil
    },
    {
      message: "System.out.println is used",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_bestpractices.html#systemprintln],
      id: "SystemPrintln",
      path: "src/Hello.java",
      location: { start_line: 8, start_column: 9, end_line: 8, end_column: 26 },
      object: { ruleset: "Best Practices", priority: "2" },
      git_blame_info: nil
    }
  ],
  warnings: [{ message: %r{PMDException: Error while parsing .+/src/Broken\.java}, file: "src/Broken.java" }]
)

# `java-optimizations` has become an old ruleset style since 6.0.0. However this style still kept for backwards-compatibility.
s.add_test(
  "old-rulesets-style",
  type: "success",
  analyzer: { name: "PMD Java", version: "6.21.0" },
  issues: [
    {
      message: "Parameter 'args' is not assigned and could be declared final",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_codestyle.html#methodargumentcouldbefinal],
      id: "MethodArgumentCouldBeFinal",
      path: "Main.java",
      location: { start_line: 5, start_column: 29, end_line: 5, end_column: 41 },
      object: { ruleset: "Code Style", priority: "3" },
      git_blame_info: nil
    }
  ],
  warnings: [
    {
      message:
        "Use Rule name category/java/codestyle.xml/LocalVariableCouldBeFinal instead of the deprecated Rule name rulesets/java/optimizations.xml/LocalVariableCouldBeFinal. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    },
    {
      message:
        "Use Rule name category/java/codestyle.xml/MethodArgumentCouldBeFinal instead of the deprecated Rule name rulesets/java/optimizations.xml/MethodArgumentCouldBeFinal. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    },
    {
      message:
        "Use Rule name category/java/codestyle.xml/PrematureDeclaration instead of the deprecated Rule name rulesets/java/optimizations.xml/PrematureDeclaration. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    },
    {
      message:
        "Use Rule name category/java/performance.xml/AddEmptyString instead of the deprecated Rule name rulesets/java/optimizations.xml/AddEmptyString. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    },
    {
      message:
        "Use Rule name category/java/performance.xml/AvoidArrayLoops instead of the deprecated Rule name rulesets/java/optimizations.xml/AvoidArrayLoops. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    },
    {
      message:
        "Use Rule name category/java/performance.xml/AvoidInstantiatingObjectsInLoops instead of the deprecated Rule name rulesets/java/optimizations.xml/AvoidInstantiatingObjectsInLoops. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    },
    {
      message:
        "Use Rule name category/java/performance.xml/RedundantFieldInitializer instead of the deprecated Rule name rulesets/java/optimizations.xml/RedundantFieldInitializer. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    },
    {
      message:
        "Use Rule name category/java/performance.xml/SimplifyStartsWith instead of the deprecated Rule name rulesets/java/optimizations.xml/SimplifyStartsWith. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    },
    {
      message:
        "Use Rule name category/java/performance.xml/UnnecessaryWrapperObjectCreation instead of the deprecated Rule name rulesets/java/optimizations.xml/UnnecessaryWrapperObjectCreation. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    },
    {
      message:
        "Use Rule name category/java/performance.xml/UseArrayListInsteadOfVector instead of the deprecated Rule name rulesets/java/optimizations.xml/UseArrayListInsteadOfVector. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    },
    {
      message:
        "Use Rule name category/java/performance.xml/UseArraysAsList instead of the deprecated Rule name rulesets/java/optimizations.xml/UseArraysAsList. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    },
    {
      message:
        "Use Rule name category/java/performance.xml/UseStringBufferForStringAppends instead of the deprecated Rule name rulesets/java/optimizations.xml/UseStringBufferForStringAppends. PMD 7.0.0 will remove support for this deprecated Rule name usage.",
      file: nil
    }
  ]
)

s.add_test(
  "config",
  type: "success",
  analyzer: { name: "PMD Java", version: "6.21.0" },
  issues: [
    {
      message: "Parameter 'args' is not assigned and could be declared final",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_codestyle.html#methodargumentcouldbefinal],
      id: "MethodArgumentCouldBeFinal",
      path: "src/Main.java",
      location: { start_line: 5, start_column: 29, end_line: 5, end_column: 41 },
      object: { ruleset: "Code Style", priority: "3" },
      git_blame_info: nil
    },
    {
      message: "Avoid short class names like Main",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_codestyle.html#shortclassname],
      id: "ShortClassName",
      path: "src/Main.java",
      location: { start_line: 3, start_column: 8, end_line: 8, end_column: 1 },
      object: { ruleset: "Code Style", priority: "4" },
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "duplicate-rule-name",
  type: "success",
  analyzer: { name: "PMD Java", version: "6.21.0" },
  issues: [
    {
      message: "Comment is too large: Line too long",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_documentation.html#commentsize],
      id: "CommentSize",
      path: "Main.java",
      location: { start_line: 10, start_column: 1, end_line: 10, end_column: 2 },
      object: { ruleset: "Documentation", priority: "3" },
      git_blame_info: nil
    },
    {
      message: "Comment is too large: Too many lines",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_documentation.html#commentsize],
      id: "CommentSize",
      path: "Main.java",
      location: { start_line: 10, start_column: 1, end_line: 34, end_column: 2 },
      object: { ruleset: "Documentation", priority: "3" },
      git_blame_info: nil
    }
  ]
)

s.add_test(
  "failure",
  type: "failure",
  analyzer: { name: "PMD Java", version: "6.21.0" },
  message: "Unexpected error occurred. Please see the analysis log."
)

s.add_test(
  "deprecated-functions",
  type: "success",
  analyzer: { name: "PMD Java", version: "6.21.0" },
  issues: [
    {
      message: "violation message",
      links: [],
      id: "typeof is deprecated",
      path: "Foo.java",
      location: { start_line: 3, start_column: 8, end_line: 3, end_column: 37 },
      object: { ruleset: "Custom Rules", priority: "3" },
      git_blame_info: nil
    }
  ],
  warnings: [
    {
      message: "The XPath function typeof() is deprecated and will be removed in 7.0.0. Use typeIs() instead.",
      file: nil
    }
  ]
)

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  analyzer: :_,
  message:
    "The value of the attribute `$.linter.pmd_java.min_priority` in your `sideci.yml` is invalid. Please fix and retry."
)

s.add_test(
  "deprecated-rules",
  type: "success",
  analyzer: { name: "PMD Java", version: "6.21.0" },
  issues: [
    {
      message: "The String literal \"Howdy\" appears 4 times in this file; the first occurrence is on line 3",
      links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_errorprone.html#avoidduplicateliterals],
      id: "AvoidDuplicateLiterals",
      path: "AvoidDupliatedLiterals.java",
      location: { start_line: 3, start_column: 13, end_line: 3, end_column: 19 },
      object: { ruleset: "Error Prone", priority: "3" },
      git_blame_info: nil
    }
  ],
  warnings: [
    {
      message:
        "Rule AvoidDuplicateLiterals uses deprecated property 'exceptionFile'. Future versions of PMD will remove support for this property. Please use 'exceptionList' instead.",
      file: nil
    }
  ]
)
