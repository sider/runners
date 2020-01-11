# Sider Runners

[![CircleCI](https://circleci.com/gh/sider/runners.svg?style=svg)](https://circleci.com/gh/sider/runners)

This is a Sider analyzer framework.

See also another related project, called [devon_rex](https://github.com/sider/devon_rex).

## Supported analyzers

All analyzers are provided as a Docker image.

*(in alphabetical order)*

- [Brakeman](https://hub.docker.com/r/sider/runner_brakeman)
- [Checkstyle](https://hub.docker.com/r/sider/runner_checkstyle)
- [CoffeeLint](https://hub.docker.com/r/sider/runner_coffeelint)
- [Cppcheck](https://hub.docker.com/r/sider/runner_cppcheck)
- [cpplint](https://hub.docker.com/r/sider/runner_cpplint)
- [ESLint](https://hub.docker.com/r/sider/runner_eslint)
- [Flake8](https://hub.docker.com/r/sider/runner_flake8)
- [go vet](https://hub.docker.com/r/sider/runner_go_vet)
- [GolangCI-Lint](https://hub.docker.com/r/sider/runner_golangcli_lint)
- [Golint](https://hub.docker.com/r/sider/runner_golint)
- [Go Meta Linter](https://hub.docker.com/r/sider/runner_gometalinter)
- [Goodcheck](https://hub.docker.com/r/sider/runner_goodcheck)
- [hadolint](https://hub.docker.com/r/sider/runner_hadolint)
- [HAML-Lint](https://hub.docker.com/r/sider/runner_haml_lint)
- [JSHint](https://hub.docker.com/r/sider/runner_jshint)
- [JavaSee](https://hub.docker.com/r/sider/runner_javasee)
- [ktlint](https://hub.docker.com/r/sider/runner_ktlint)
- [Misspell](https://hub.docker.com/r/sider/runner_misspell)
- [PHPMD](https://hub.docker.com/r/sider/runner_phpmd)
- [PHP_CodeSniffer](https://hub.docker.com/r/sider/runner_code_sniffer)
- [PMD Java](https://hub.docker.com/r/sider/runner_pmd_java)
- [Phinder](https://hub.docker.com/r/sider/runner_phinder)
- [Querly](https://hub.docker.com/r/sider/runner_querly)
- [Rails Best Practices](https://hub.docker.com/r/sider/runner_rails_best_practices)
- [Reek](https://hub.docker.com/r/sider/runner_reek)
- [RuboCop](https://hub.docker.com/r/sider/runner_rubocop)
- [SCSS-Lint](https://hub.docker.com/r/sider/runner_scss_lint)
- [ShellCheck](https://hub.docker.com/r/sider/runner_shellcheck)
- [stylelint](https://hub.docker.com/r/sider/runner_stylelint)
- [SwiftLint](https://hub.docker.com/r/sider/runner_swiftlint)
- [TSLint](https://hub.docker.com/r/sider/runner_tslint)
- [TyScan](https://hub.docker.com/r/sider/runner_tyscan)

## Developer guide

Please follow these instructions.

### Prerequisites

- Ruby (see [`.ruby-version`](.ruby-version))
- Bundler (see [`Gemfile.lock`](Gemfile.lock))
- Docker (the latest version recommended)

### Setup

First, after checking out the source code, run the following command to install Ruby:

```shell
$ rbenv insall
```

If you don't want to use [rbenv](https://github.com/rbenv/rbenv), you need to manually install Ruby with the version in the [`.ruby-version`](.ruby-version) file.

Next, let's install gem dependencies via [Bundler](https://bundler.io):

```shell
$ bundle install
```

Then, run the following command to show available commands in the project:

```shell
$ bundle exec rake --tasks
```

These commands will help you develop! :wink:

### Project structure

```shell
$ tree -F -L 1 -d
.
├── bin
├── docs
├── images
├── lib
├── sig
└── test

6 directories
```

- `bin`: Entry point to launch a runner
- `docs`: Documents
- `images`: Docker images
- `lib`: Core programs
- `sig`: Ruby signature files for type-checking
- `test`: Unit tests and smoke tests

### Testing

#### Unit test

You can run unit tests via the `rake test` command as follow.

All tests:

```shell
$ bundle exec rake test
```

Only a test file:

```shell
$ bundle exec rake test TEST=test/cli_test.rb
```

Only a test method:

```shell
$ bundle exec rake test TEST=test/cli_test.rb TESTOPTS='--name=test_parsing_options'
```

#### Smoke test

You can run smoke tests via the `rake docker:smoke` command as follow:

```shell
$ bundle exec rake docker:smoke ANALYZER=rubocop [ONLY=test1,test2,...] [SHOW_TRACE=true]
```

- `ONLY`: Specify test name(s). You can specify a comma-separated list.
- `SHOW_TRACE`: Show trace log to console. Useful to debug.

If you want to run tests right after changing code, you can run one command as follow:

```shell
$ bundle exec rake docker:build docker:smoke ANALYZER=rubocop
```

## License

See [LICENSE](LICENSE).
