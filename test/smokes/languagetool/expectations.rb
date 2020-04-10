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
        links: [],
        path: "sample.txt",
        location: nil,
        message:
          "Use \"a\" instead of 'an' if the following word doesn't start with a vowel sound, e.g. 'a sentence', 'a university' -> or use this text to see an few of the problems that LanguageTool can detecd.",
        object: nil,
        git_blame_info: nil
      },
      {
        id: "MORFOLOGIK_RULE_EN_US",
        links: [],
        path: "sample.txt",
        location: nil,
        message:
          "Possible spelling mistake found -> or use this text to see an few of the problems that LanguageTool can detecd.",
        object: nil,
        git_blame_info: nil
      },
      {
        id: "UPPERCASE_SENTENCE_START",
        links: [],
        path: "sample.txt",
        location: nil,
        message:
          "This sentence does not start with an uppercase letter -> or use this text to see an few of the problems that LanguageTool can detecd.",
        object: nil,
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
