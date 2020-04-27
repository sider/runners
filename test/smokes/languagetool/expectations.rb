s = Runners::Testing::Smoke

s.add_test(
  "success",
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
        category: "MISC",
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
        category: "TYPOS",
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
      object: { sentence: "This is a.", type: "grammar", category: "GRAMMAR", replacements: [] },
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
        category: "CASING",
        replacements: %w[To]
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "LanguageTool", version: "4.9" }
)

s.add_test(
  "option_language",
  type: "success",
  issues: [
    {
      id: "DOUSI_KOTOGADEKIRU",
      path: "sample.txt",
      location: { start_line: 1 },
      message: "省略が可能です。暮\"らせる\"",
      links: [],
      object: {
        sentence: "これわ文章を入力して'CheckText'をクリックすると、誤記を探すことができる。",
        type: "uncategorized",
        category: "CAT1",
        replacements: %w[らせる]
      },
      git_blame_info: nil
    },
    {
      id: "KOREWA",
      path: "sample.txt",
      location: { start_line: 1 },
      message: "文法ミスがあります。\"これは\"の間違いです。",
      links: [],
      object: {
        sentence: "これわ文章を入力して'CheckText'をクリックすると、誤記を探すことができる。",
        type: "uncategorized",
        category: "CAT1",
        replacements: %w[これは]
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "LanguageTool", version: "4.9" }
)

s.add_test(
  "option_target",
  type: "success",
  issues: [
    {
      id: "MORFOLOGIK_RULE_EN_US",
      path: "dir/incorrect.txt",
      location: { start_line: 1 },
      message: "Possible spelling mistake found.",
      links: [],
      object: { sentence: "Thes is correct text.", type: "misspelling", category: "TYPOS", replacements: :_ },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "LanguageTool", version: "4.9" }
)

s.add_test(
  "option_ext",
  type: "success",
  issues: [
    {
      id: "EN_QUOTES",
      path: "target.html",
      location: { start_line: 3 },
      message: "Use a smart closing quote here: \"”\".",
      links: [],
      object: {
        sentence: "<p class=\"normal\">This is a sample <em>HTML</em> file.</p>",
        type: "typographical",
        category: "TYPOGRAPHY",
        replacements: %w[”]
      },
      git_blame_info: nil
    },
    {
      id: "EN_QUOTES",
      path: "target.html",
      location: { start_line: 3 },
      message: "Use a smart closing quote here: \"”\".",
      links: [],
      object: {
        sentence: "<p class=\"normal\">This is a sample <em>HTML</em> file.</p>",
        type: "typographical",
        category: "TYPOGRAPHY",
        replacements: %w[”]
      },
      git_blame_info: nil
    },
    {
      id: "MORFOLOGIK_RULE_EN_US",
      path: "target.md",
      location: { start_line: 3 },
      message: "Possible spelling mistake found.",
      links: [],
      object: {
        sentence: "This is a sample [markdow](https://en.wikipedia.org/wiki/Markdown) file.",
        type: "misspelling",
        category: "TYPOS",
        replacements: %w[markdown]
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "LanguageTool", version: "4.9" }
)

s.add_test(
  "option_exclude",
  type: "success",
  issues: [
    {
      id: "UPPERCASE_SENTENCE_START",
      path: "target.txt",
      location: { start_line: 1 },
      message: "This sentence does not start with an uppercase letter",
      links: [],
      object: { sentence: "this is a pen.", type: "typographical", category: "CASING", replacements: %w[This] },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "LanguageTool", version: "4.9" }
)

s.add_test(
  "option_encoding",
  type: "success",
  issues: [
    {
      id: "KOREWA",
      path: "sample.txt",
      location: { start_line: 1 },
      message: "文法ミスがあります。\"これは\"の間違いです。",
      links: [],
      object: { sentence: "これわペンです。", type: "uncategorized", category: "CAT1", replacements: %w[これは] },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "LanguageTool", version: "4.9" }
)

s.add_test("option_disable", type: "success", issues: [], analyzer: { name: "LanguageTool", version: "4.9" })

s.add_test(
  "option_enable",
  type: "success",
  issues: [
    {
      id: "UPPERCASE_SENTENCE_START",
      path: "sample.txt",
      location: { start_line: 1 },
      message: "This sentence does not start with an uppercase letter",
      links: [],
      object: { sentence: "this is a.", type: "typographical", category: "CASING", replacements: %w[This] },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "LanguageTool", version: "4.9" }
)

s.add_test(
  "option_disablecategories",
  type: "success",
  issues: [
    {
      id: "THE_SENT_END",
      path: "sample.txt",
      location: { start_line: 1 },
      message: "Did you forget something after 'a'?",
      links: [],
      object: { sentence: "this is a.", type: "grammar", category: "GRAMMAR", replacements: [] },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "LanguageTool", version: "4.9" }
)

s.add_test(
  "option_enablecategories",
  type: "success",
  issues: [
    {
      id: "UPPERCASE_SENTENCE_START",
      path: "sample.txt",
      location: { start_line: 1 },
      message: "This sentence does not start with an uppercase letter",
      links: [],
      object: { sentence: "this is a.", type: "typographical", category: "CASING", replacements: %w[This] },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "LanguageTool", version: "4.9" }
)

s.add_test("no_files", type: "success", issues: [], analyzer: { name: "LanguageTool", version: "4.9" })

s.add_test(
  "invalid_options",
  type: "failure",
  message: "You cannot specify both disabled rules and enabledonly\nPlease check your `sider.yml`",
  analyzer: { name: "LanguageTool", version: "4.9" }
)
