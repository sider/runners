Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        id: "EN_A_VS_AN",
        path: "sample.txt",
        location: { start_line: 3 },
        message:
          "Use \"a\" instead of 'an' if the following word doesn't start with a vowel sound, e.g. 'a sentence', 'a university'",
        links: [],
        object: {
          sentence: "to see an few of the problems that LanguageTool can detecd.",
          type: "misspelling",
          category: "Miscellaneous",
          replacements: %w[a]
        },
        git_blame_info: nil
      },
      {
        id: "MORFOLOGIK_RULE_EN_US",
        path: "sample.txt",
        location: { start_line: 3 },
        message: "Possible spelling mistake found.",
        links: [],
        object: {
          sentence: "to see an few of the problems that LanguageTool can detecd.",
          type: "misspelling",
          category: "Possible Typo",
          replacements: %w[detect]
        },
        git_blame_info: nil
      },
      {
        id: "THE_SENT_END",
        path: "dir/foo.txt",
        location: { start_line: 1 },
        message: "Did you forget something after 'a'?",
        links: [],
        object: { sentence: "This is a.", type: "grammar", category: "Grammar", replacements: [] },
        git_blame_info: nil
      },
      {
        id: "UPPERCASE_SENTENCE_START",
        path: "sample.txt",
        location: { start_line: 3 },
        message: "This sentence does not start with an uppercase letter",
        links: [],
        object: {
          sentence: "to see an few of the problems that LanguageTool can detecd.",
          type: "typographical",
          category: "Capitalization",
          replacements: %w[To]
        },
        git_blame_info: nil
      }
    ],
    analyzer: { name: "LanguageTool", version: "4.9" }
  }
)

Smoke.add_test(
  "language_option",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        id: "DOUSI_KOTOGADEKIRU",
        links: [],
        path: "japanese/sample.txt",
        location: nil,
        message:
          "省略が可能です。暮\"らせる\" -> これわ文章を入力して'CheckText'をクリックすると、誤記を探すことができる。",
        object: nil,
        git_blame_info: nil
      },
      {
        id: "KOREWA",
        links: [],
        path: "japanese/sample.txt",
        location: nil,
        message:
          "文法ミスがあります。\"これは\"の間違いです。 -> これわ文章を入力して'CheckText'をクリックすると、誤記を探すことができる。",
        object: nil,
        git_blame_info: nil
      }
    ],
    analyzer: { name: "languagetool", version: "4.9" }
  }
)

Smoke.add_test(
  "target_file",
  { guid: "test-guid", timestamp: :_, type: "success", issues: [], analyzer: { name: "LanguageTool", version: "4.9" } }
)

# Smoke.add_test(
#   "multi_target_file",
#   {
#     guid: "test-guid",
#     timestamp: :_,
#     type: "success",
#     issues: [],
#     analyzer: { name: "LanguageTool", version: "4.9" }
#   }
# )

# Smoke.add_test(
#   "multi_language",
#   {
#     guid: "test-guid",
#     timestamp: :_,
#     type: "success",
#     issues: [],
#     analyzer: { name: "LanguageTool", version: "4.9" }
#   }
# )
