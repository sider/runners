[![Build](https://github.com/sider/runners/workflows/Build/badge.svg)](https://github.com/sider/runners/actions/workflows/build.yml?query=branch%3Amaster)

# Sider Runners

This is a Sider analyzer framework.

See also another related project, called [devon_rex](https://github.com/sider/devon_rex).

## Supported analyzers

<!-- AUTO-GENERATED-CONTENT:START (analyzers) -->
All **41** analyzers are provided as a Docker image:

| Name | Links | Status |
|:-----|:------|:------:|
| Brakeman | [docker](https://hub.docker.com/r/sider/runner_brakeman), [source](https://github.com/presidentbeef/brakeman), [doc](https://help.sider.review/tools/ruby/brakeman), [website](https://brakemanscanner.org) | ✅ |
| Checkstyle | [docker](https://hub.docker.com/r/sider/runner_checkstyle), [source](https://github.com/checkstyle/checkstyle), [doc](https://help.sider.review/tools/java/checkstyle), [website](https://checkstyle.org) | ✅ |
| Clang-Tidy | [docker](https://hub.docker.com/r/sider/runner_clang_tidy), [source](https://github.com/llvm/llvm-project), [doc](https://help.sider.review/tools/cplusplus/clang-tidy), [website](https://clang.llvm.org/extra/clang-tidy) | 🔨 |
| CoffeeLint | [docker](https://hub.docker.com/r/sider/runner_coffeelint), [source](https://github.com/coffeelint/coffeelint), [doc](https://help.sider.review/tools/javascript/coffeelint), [website](https://coffeelint.github.io) | ✅ |
| Cppcheck | [docker](https://hub.docker.com/r/sider/runner_cppcheck), [source](https://github.com/danmar/cppcheck), [doc](https://help.sider.review/tools/cplusplus/cppcheck), [website](http://cppcheck.sourceforge.net) | ✅ |
| cpplint | [docker](https://hub.docker.com/r/sider/runner_cpplint), [source](https://github.com/cpplint/cpplint), [doc](https://help.sider.review/tools/cplusplus/cpplint) | ✅ |
| detekt | [docker](https://hub.docker.com/r/sider/runner_detekt), [source](https://github.com/detekt/detekt), [doc](https://help.sider.review/tools/kotlin/detekt), [website](https://detekt.github.io/detekt) | 🔨 |
| ESLint | [docker](https://hub.docker.com/r/sider/runner_eslint), [source](https://github.com/eslint/eslint), [doc](https://help.sider.review/tools/javascript/eslint), [website](https://eslint.org) | ✅ |
| Flake8 | [docker](https://hub.docker.com/r/sider/runner_flake8), [source](https://github.com/PyCQA/flake8), [doc](https://help.sider.review/tools/python/flake8), [website](https://flake8.pycqa.org) | ✅ |
| FxCop | [docker](https://hub.docker.com/r/sider/runner_fxcop), [source](https://github.com/dotnet/roslyn-analyzers), [doc](https://help.sider.review/tools/csharp/fxcop), [website](https://docs.microsoft.com/en-us/visualstudio/code-quality/static-code-analysis-for-managed-code-overview) | 🔨 |
| GolangCI-Lint | [docker](https://hub.docker.com/r/sider/runner_golangci_lint), [source](https://github.com/golangci/golangci-lint), [doc](https://help.sider.review/tools/go/golangci-lint), [website](https://golangci-lint.run) | ✅ |
| Goodcheck | [docker](https://hub.docker.com/r/sider/runner_goodcheck), [source](https://github.com/sider/goodcheck), [doc](https://help.sider.review/tools/others/goodcheck), [website](https://sider.github.io/goodcheck) | ✅ |
| hadolint | [docker](https://hub.docker.com/r/sider/runner_hadolint), [source](https://github.com/hadolint/hadolint), [doc](https://help.sider.review/tools/dockerfile/hadolint) | ✅ |
| HAML-Lint | [docker](https://hub.docker.com/r/sider/runner_haml_lint), [source](https://github.com/sds/haml-lint), [doc](https://help.sider.review/tools/ruby/haml-lint) | ✅ |
| JavaSee | [docker](https://hub.docker.com/r/sider/runner_javasee), [source](https://github.com/sider/JavaSee), [doc](https://help.sider.review/tools/java/javasee) | ✅ |
| JSHint | [docker](https://hub.docker.com/r/sider/runner_jshint), [source](https://github.com/jshint/jshint), [doc](https://help.sider.review/tools/javascript/jshint), [website](https://jshint.com) | ✅ |
| ktlint | [docker](https://hub.docker.com/r/sider/runner_ktlint), [source](https://github.com/pinterest/ktlint), [doc](https://help.sider.review/tools/kotlin/ktlint), [website](https://ktlint.github.io) | 🔨 |
| LanguageTool | [docker](https://hub.docker.com/r/sider/runner_languagetool), [source](https://github.com/languagetool-org/languagetool), [doc](https://help.sider.review/tools/others/languagetool), [website](https://languagetool.org) | 🔨 |
| Metrics Code Clone | [docker](https://hub.docker.com/r/sider/runner_metrics_codeclone), [source](https://github.com/pmd/pmd), [doc](https://help.sider.review/) | 🔨 |
| Metrics Complexity | [docker](https://hub.docker.com/r/sider/runner_metrics_complexity), [source](https://github.com/terryyin/lizard), [doc](https://help.sider.review/) | 🔨 |
| Metrics File Info | [docker](https://hub.docker.com/r/sider/runner_metrics_fileinfo), [source](https://github.com/coreutils/coreutils), [doc](https://help.sider.review/) | 🔨 |
| Misspell | [docker](https://hub.docker.com/r/sider/runner_misspell), [source](https://github.com/client9/misspell), [doc](https://help.sider.review/tools/others/misspell) | ✅ |
| Phinder | [docker](https://hub.docker.com/r/sider/runner_phinder), [source](https://github.com/sider/phinder), [doc](https://help.sider.review/tools/php/phinder) | ✅ |
| PHP_CodeSniffer | [docker](https://hub.docker.com/r/sider/runner_code_sniffer), [source](https://github.com/squizlabs/PHP_CodeSniffer), [doc](https://help.sider.review/tools/php/code-sniffer) | ✅ |
| PHPMD | [docker](https://hub.docker.com/r/sider/runner_phpmd), [source](https://github.com/phpmd/phpmd), [doc](https://help.sider.review/tools/php/phpmd), [website](https://phpmd.org) | ✅ |
| PMD CPD | [docker](https://hub.docker.com/r/sider/runner_pmd_cpd), [source](https://github.com/pmd/pmd), [doc](https://help.sider.review/tools/others/pmd-cpd), [website](https://pmd.github.io) | 🔨 |
| PMD Java | [docker](https://hub.docker.com/r/sider/runner_pmd_java), [source](https://github.com/pmd/pmd), [doc](https://help.sider.review/tools/java/pmd), [website](https://pmd.github.io) | ✅ |
| Pylint | [docker](https://hub.docker.com/r/sider/runner_pylint), [source](https://github.com/PyCQA/pylint), [doc](https://help.sider.review/tools/python/pylint), [website](https://pylint.pycqa.org) | 🔨 |
| Querly | [docker](https://hub.docker.com/r/sider/runner_querly), [source](https://github.com/soutaro/querly), [doc](https://help.sider.review/tools/ruby/querly) | ✅ |
| Rails Best Practices | [docker](https://hub.docker.com/r/sider/runner_rails_best_practices), [source](https://github.com/flyerhzm/rails_best_practices), [doc](https://help.sider.review/tools/ruby/rails-best-practices), [website](https://rails-bestpractices.com) | ⚠️ |
| Reek | [docker](https://hub.docker.com/r/sider/runner_reek), [source](https://github.com/troessner/reek), [doc](https://help.sider.review/tools/ruby/reek) | ✅ |
| remark-lint | [docker](https://hub.docker.com/r/sider/runner_remark_lint), [source](https://github.com/remarkjs/remark-lint), [doc](https://help.sider.review/tools/markdown/remark-lint) | ✅ |
| RuboCop | [docker](https://hub.docker.com/r/sider/runner_rubocop), [source](https://github.com/rubocop/rubocop), [doc](https://help.sider.review/tools/ruby/rubocop), [website](https://rubocop.org) | ✅ |
| SCSS-Lint | [docker](https://hub.docker.com/r/sider/runner_scss_lint), [source](https://github.com/sds/scss-lint), [doc](https://help.sider.review/tools/css/scss-lint) | ⚠️ |
| Secret Scan | [docker](https://hub.docker.com/r/sider/runner_secret_scan), [doc](https://help.sider.review/tools/others/secret-scan) | 🔨 |
| ShellCheck | [docker](https://hub.docker.com/r/sider/runner_shellcheck), [source](https://github.com/koalaman/shellcheck), [doc](https://help.sider.review/tools/shellscript/shellcheck), [website](https://www.shellcheck.net) | ✅ |
| Slim-Lint | [docker](https://hub.docker.com/r/sider/runner_slim_lint), [source](https://github.com/sds/slim-lint), [doc](https://help.sider.review/tools/ruby/slim-lint) | 🔨 |
| stylelint | [docker](https://hub.docker.com/r/sider/runner_stylelint), [source](https://github.com/stylelint/stylelint), [doc](https://help.sider.review/tools/css/stylelint), [website](https://stylelint.io) | ✅ |
| SwiftLint | [docker](https://hub.docker.com/r/sider/runner_swiftlint), [source](https://github.com/realm/SwiftLint), [doc](https://help.sider.review/tools/swift/swiftlint), [website](https://realm.github.io/SwiftLint) | ✅ |
| TSLint | [docker](https://hub.docker.com/r/sider/runner_tslint), [source](https://github.com/palantir/tslint), [doc](https://help.sider.review/tools/javascript/tslint), [website](https://palantir.github.io/tslint) | ⚠️ |
| TyScan | [docker](https://hub.docker.com/r/sider/runner_tyscan), [source](https://github.com/sider/TyScan), [doc](https://help.sider.review/tools/javascript/tyscan) | ✅ |

✅ - active, ⚠️ - deprecated, 🔨 - beta
<!-- AUTO-GENERATED-CONTENT:END (analyzers) -->

## Developer guide

Please follow these instructions.

### Prerequisites

- Ruby (see [`.ruby-version`](.ruby-version))
- Bundler (see [`Gemfile.lock`](Gemfile.lock))
- Docker (the latest version recommended)
- EditorConfig (see [`.editorconfig`](.editorconfig), and setup your editor)

### Setup

First, after checking out the source code, run the following command to install Ruby:

```shell-session
$ rbenv install
```

If you don't want to use [rbenv](https://github.com/rbenv/rbenv), you need to manually install Ruby with the version in the [`.ruby-version`](.ruby-version) file.

Next, let's set up via [Bundler](https://bundler.io):

```shell-session
$ bin/setup
```

All is done. The [Rake](https://ruby.github.io/rake/) tasks will help you develop! :wink:

### Project structure

```shell-session
$ tree -F -L 1 -d
.
├── bin
├── docs
├── exe
├── images
├── lib
├── sig
├── tasks
└── test

6 directories
```

- `bin`: Scripts
- `docs`: Documents
- `exe`: Entry point
- `images`: Docker images
- `lib`: Core programs
- `sig`: Ruby signature files for type-checking
- `tasks`: Rake tasks
- `test`: Unit tests and smoke tests

### Testing

#### Unit test

You can run unit tests via the `rake test` command as follow.

All tests:

```shell-session
$ bundle exec rake test
```

Only a test file:

```shell-session
$ bundle exec rake test TEST=test/cli_test.rb
```

Only a test method:

```shell-session
$ bundle exec rake test TEST=test/cli_test.rb TESTOPTS='--name=test_parsing_options'
```

#### Smoke test

You can run smoke tests via the `rake docker:smoke` command as follow:

```shell-session
$ bundle exec rake docker:smoke ANALYZER=rubocop [ONLY=test1,test2,...] [DEBUG=(true|trace)]
```

- `ONLY`: Specify test name(s). You can specify a comma-separated list.
- `DEBUG`: Show debug log to your console.
  - `DEBUG=true`: All log.
  - `DEBUG=trace`: Only trace log (colored).

If you want to run tests right after changing code, you can run one command as follow:

```shell-session
$ bundle exec rake docker:build docker:smoke ANALYZER=rubocop
```

### Debugging

You can use the `rake docker:shell` command to run a command directly in a Docker container, for example:

```shell-session
$ bundle exec rake docker:build docker:shell ANALYZER=rubocop
docker run ...
analyzer_runner@838f831e5aa7:/work$ cd test/smokes/rubocop/renamed-cop
analyzer_runner@838f831e5aa7:/work$ rubocop .
...
```

### Type checking

We check the types of our Ruby source files via [RBS](https://github.com/ruby/rbs) and [Steep](https://github.com/soutaro/steep).

```shell-session
$ bundle exec steep check [files_or_directories...]
```

To update the third-party gems' RBS, run:

```shell-session
$ bundle exec rake rbs:update_gems
```

## License

See [LICENSE](LICENSE).
