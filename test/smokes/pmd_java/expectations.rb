Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "pmd_java", version: "6.21.0" },
    issues: [
      {
        message: "System.out.println is used",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_bestpractices.html#systemprintln],
        id: "Best Practices-SystemPrintln-df6e8cab6195f150091bd209ddf59cb021c1253f",
        path: "src/Hello.java",
        location: { start_line: 8, start_column: 9, end_line: 8, end_column: 26 },
        object: { rule: "SystemPrintln", ruleset: "Best Practices", priority: "2" },
        git_blame_info: nil
      },
      {
        message: "Exceptions should not extend java.lang.Error",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_design.html#donotextendjavalangerror],
        id: "Design-DoNotExtendJavaLangError-0b2aff78dc670589916e646ac1baaed1b54c42ce",
        path: "src/Hello.java",
        location: { start_line: 22, start_column: 23, end_line: 22, end_column: 37 },
        object: { rule: "DoNotExtendJavaLangError", ruleset: "Design", priority: "3" },
        git_blame_info: nil
      },
      {
        message: "Avoid calling finalize() explicitly",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_errorprone.html#avoidcallingfinalize],
        id: "Error Prone-AvoidCallingFinalize-7bdb2db247d3add8015ac781df2fa31f6b96e8a0",
        path: "src/Hello.java",
        location: { start_line: 16, start_column: 9, end_line: 16, end_column: 16 },
        object: { rule: "AvoidCallingFinalize", ruleset: "Error Prone", priority: "3" },
        git_blame_info: nil
      },
      {
        message: "Use block level rather than method level synchronization",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_multithreading.html#avoidsynchronizedatmethodlevel],
        id: "Multithreading-AvoidSynchronizedAtMethodLevel-b2c1ab4091cac62dc0fc8deaed88b02112630fb5",
        path: "src/Hello.java",
        location: { start_line: 20, start_column: 18, end_line: 20, end_column: 29 },
        object: { rule: "AvoidSynchronizedAtMethodLevel", ruleset: "Multithreading", priority: "3" },
        git_blame_info: nil
      },
      {
        message: "Do not add empty strings",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_performance.html#addemptystring],
        id: "Performance-AddEmptyString-fd246dd4ea41af8d04a83d07a2ef863361c58485",
        path: "src/Hello.java",
        location: { start_line: 17, start_column: 16, end_line: 17, end_column: 17 },
        object: { rule: "AddEmptyString", ruleset: "Performance", priority: "3" },
        git_blame_info: nil
      },
      {
        message: "Do not use hard coded encryption keys",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_security.html#hardcodedcryptokey],
        id: "Security-HardCodedCryptoKey-56ecc791913c2de643028e865009d40653205dcf",
        path: "src/Hello.java",
        location: { start_line: 12, start_column: 27, end_line: 12, end_column: 42 },
        object: { rule: "HardCodedCryptoKey", ruleset: "Security", priority: "3" },
        git_blame_info: nil
      }
    ]
  },
  warnings: [{ message: %r{PMDException: Error while parsing .+/src/Broken\.java}, file: "src/Broken.java" }]
)

# `java-optimizations` has become an old ruleset style since 6.0.0. However this style still kept for backwards-compatibility.
Smoke.add_test(
  "old-rulesets-style",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "pmd_java", version: "6.21.0" },
    issues: [
      {
        message: "Parameter 'args' is not assigned and could be declared final",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_codestyle.html#methodargumentcouldbefinal],
        id: "Code Style-MethodArgumentCouldBeFinal-f7008600fe4fd7c0e84e4910bcd4a4b7b8c41b67",
        path: "Main.java",
        location: { start_line: 5, start_column: 29, end_line: 5, end_column: 41 },
        object: { rule: "MethodArgumentCouldBeFinal", ruleset: "Code Style", priority: "3" },
        git_blame_info: nil
      }
    ]
  },
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

Smoke.add_test(
  "config",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "pmd_java", version: "6.21.0" },
    issues: [
      {
        message: "Parameter 'args' is not assigned and could be declared final",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_codestyle.html#methodargumentcouldbefinal],
        id: "Code Style-MethodArgumentCouldBeFinal-f7008600fe4fd7c0e84e4910bcd4a4b7b8c41b67",
        path: "src/Main.java",
        location: { start_line: 5, start_column: 29, end_line: 5, end_column: 41 },
        object: { rule: "MethodArgumentCouldBeFinal", ruleset: "Code Style", priority: "3" },
        git_blame_info: nil
      },
      {
        message: "Avoid short class names like Main",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_codestyle.html#shortclassname],
        id: "Code Style-ShortClassName-06b374edd6bbc3bb8ea848f704304de5f14ca11a",
        path: "src/Main.java",
        location: { start_line: 3, start_column: 8, end_line: 8, end_column: 1 },
        object: { rule: "ShortClassName", ruleset: "Code Style", priority: "4" },
        git_blame_info: nil
      }
    ]
  }
)

Smoke.add_test(
  "duplicate-rule-name",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "pmd_java", version: "6.21.0" },
    issues: [
      {
        message: "Comment is too large: Too many lines",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_documentation.html#commentsize],
        id: "Documentation-CommentSize-10c545bd6ffe0bb7c6551a1191762accb45679b9",
        path: "Main.java",
        location: { start_line: 10, start_column: 1, end_line: 34, end_column: 2 },
        object: { rule: "CommentSize", ruleset: "Documentation", priority: "3" },
        git_blame_info: nil
      },
      {
        message: "Comment is too large: Line too long",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_documentation.html#commentsize],
        id: "Documentation-CommentSize-ae3f424f4ea74990ded4b6dc9ae2cdc55048b9a6",
        path: "Main.java",
        location: { start_line: 10, start_column: 1, end_line: 10, end_column: 2 },
        object: { rule: "CommentSize", ruleset: "Documentation", priority: "3" },
        git_blame_info: nil
      }
    ]
  }
)

Smoke.add_test(
  "failure",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    analyzer: { name: "pmd_java", version: "6.21.0" },
    message: "Unexpected error occurred. Please see the analysis log."
  }
)

Smoke.add_test(
  "deprecated-functions",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "pmd_java", version: "6.21.0" },
    issues: [
      {
        message: "violation message",
        links: [],
        id: "Custom Rules-typeof is deprecated-c887b4750ce655634fbf91df220ddffaddd09df0",
        path: "Foo.java",
        location: { start_line: 3, start_column: 8, end_line: 3, end_column: 37 },
        object: { rule: "typeof is deprecated", ruleset: "Custom Rules", priority: "3" },
        git_blame_info: nil
      }
    ]
  },
  warnings: [
    {
      message: "The XPath function typeof() is deprecated and will be removed in 7.0.0. Use typeIs() instead.",
      file: nil
    }
  ]
)

Smoke.add_test(
  "broken_sideci_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    analyzer: nil,
    message: "The value of the attribute `$.linter.pmd_java.min_priority` of `sideci.yml` is invalid."
  }
)

Smoke.add_test(
  "deprecated-rules",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "pmd_java", version: "6.21.0" },
    issues: [
      {
        message: "The String literal \"Howdy\" appears 4 times in this file; the first occurrence is on line 3",
        links: %w[https://pmd.github.io/pmd-6.21.0/pmd_rules_java_errorprone.html#avoidduplicateliterals],
        id: "Error Prone-AvoidDuplicateLiterals-28a11656e010dd99ee7ca2fa590407e3007bee18",
        path: "AvoidDupliatedLiterals.java",
        location: { start_line: 3, start_column: 13, end_line: 3, end_column: 19 },
        object: { rule: "AvoidDuplicateLiterals", ruleset: "Error Prone", priority: "3" },
        git_blame_info: nil
      }
    ]
  },
  warnings: [
    {
      message:
        "Rule AvoidDuplicateLiterals uses deprecated property 'exceptionFile'. Future versions of PMD will remove support for this property. Please use 'exceptionList' instead.",
      file: nil
    }
  ]
)
