s = Runners::Testing::Smoke

default_version = "5.0"

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
      git_blame_info: {
        commit: :_, line_hash: "afaa1ff10e427624490175bccb46b6f06698d675", original_line: 3, final_line: 3
      }
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
      git_blame_info: {
        commit: :_, line_hash: "afaa1ff10e427624490175bccb46b6f06698d675", original_line: 3, final_line: 3
      }
    },
    {
      id: "THE_SENT_END",
      path: "dir/foo.txt",
      location: { start_line: 1 },
      message: "Did you forget something after 'a'?",
      links: [],
      object: { sentence: "This is a.", type: "grammar", category: "GRAMMAR", replacements: [] },
      git_blame_info: {
        commit: :_, line_hash: "0c008b29c5cd07377b216a8b72b6e41c1721cd97", original_line: 1, final_line: 1
      }
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
      git_blame_info: {
        commit: :_, line_hash: "afaa1ff10e427624490175bccb46b6f06698d675", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "LanguageTool", version: default_version }
)

s.add_test(
  "option_language",
  type: "success",
  issues: [
    {
      id: "DOUSI_KOTOGADEKIRU",
      path: "sample.txt",
      location: { start_line: 1 },
      message: '省略が可能です。暮"らせる"',
      links: [],
      object: {
        sentence: "これわ文章を入力して'CheckText'をクリックすると、誤記を探すことができる。",
        type: "uncategorized",
        category: "CAT1",
        replacements: %w[らせる]
      },
      git_blame_info: {
        commit: :_, line_hash: "f58950c9802f512f45ec145179d7640c7ff0064d", original_line: 1, final_line: 1
      }
    },
    {
      id: "KOREWA",
      path: "sample.txt",
      location: { start_line: 1 },
      message: '文法ミスがあります。"これは"の間違いです。',
      links: [],
      object: {
        sentence: "これわ文章を入力して'CheckText'をクリックすると、誤記を探すことができる。",
        type: "uncategorized",
        category: "CAT1",
        replacements: %w[これは]
      },
      git_blame_info: {
        commit: :_, line_hash: "f58950c9802f512f45ec145179d7640c7ff0064d", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "LanguageTool", version: default_version }
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
      git_blame_info: {
        commit: :_, line_hash: "0cbacf507153681964e147d803234872c33a3141", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "LanguageTool", version: default_version }
)

s.add_test(
  "option_ext",
  type: "success",
  issues: [
    {
      id: "EN_QUOTES",
      path: "target.html",
      location: { start_line: 3 },
      message: 'Use a smart closing quote here: "”".',
      links: [],
      object: {
        sentence: '<p class="normal">This is a sample <em>HTML</em> file.</p>',
        type: "typographical",
        category: "TYPOGRAPHY",
        replacements: %w[”]
      },
      git_blame_info: {
        commit: :_, line_hash: "1ef5a9be332328cae50b56633d537394351bf340", original_line: 3, final_line: 3
      }
    },
    {
      id: "EN_QUOTES",
      path: "target.html",
      location: { start_line: 3 },
      message: 'Use a smart closing quote here: "”".',
      links: [],
      object: {
        sentence: '<p class="normal">This is a sample <em>HTML</em> file.</p>',
        type: "typographical",
        category: "TYPOGRAPHY",
        replacements: %w[”]
      },
      git_blame_info: {
        commit: :_, line_hash: "1ef5a9be332328cae50b56633d537394351bf340", original_line: 3, final_line: 3
      }
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
      git_blame_info: {
        commit: :_, line_hash: "0cd318e72c6c0682c98b6174a41887e9a1764c16", original_line: 3, final_line: 3
      }
    }
  ],
  analyzer: { name: "LanguageTool", version: default_version }
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
      git_blame_info: {
        commit: :_, line_hash: "ed91ea0a3aa8fe388192803b227013817ddf2c31", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "LanguageTool", version: default_version }
)

s.add_test(
  "option_encoding",
  type: "success",
  issues: [
    {
      id: "KOREWA",
      path: "sample.txt",
      location: { start_line: 1 },
      message: '文法ミスがあります。"これは"の間違いです。',
      links: [],
      object: { sentence: "これわペンです。", type: "uncategorized", category: "CAT1", replacements: %w[これは] },
      git_blame_info: {
        commit: :_, line_hash: "ad6f1f92e84b1c1d0b16f9fdb829a92ad0fb1332", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "LanguageTool", version: default_version }
)

s.add_test("option_disable", type: "success", issues: [], analyzer: { name: "LanguageTool", version: default_version })

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
      git_blame_info: {
        commit: :_, line_hash: "737d1edfad239510029791a1592065c9a9d01337", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "LanguageTool", version: default_version }
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
      git_blame_info: {
        commit: :_, line_hash: "737d1edfad239510029791a1592065c9a9d01337", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "LanguageTool", version: default_version }
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
      git_blame_info: {
        commit: :_, line_hash: "737d1edfad239510029791a1592065c9a9d01337", original_line: 1, final_line: 1
      }
    }
  ],
  analyzer: { name: "LanguageTool", version: default_version }
)

s.add_test("no_files", type: "success", issues: [], analyzer: { name: "LanguageTool", version: default_version })

s.add_test(
  "invalid_options",
  type: "failure",
  message: "You cannot specify both disabled rules and enabledonly\nPlease check your `sider.yml`",
  analyzer: { name: "LanguageTool", version: default_version }
)
