# How to write a new runner

This document describes how to write a new runner when you are going to support a new tool.

You need to finish the [setup](../README.md#setup) before performing the following tasks.

## Tasks

- [Create a base image](#create-a-base-image)
- [Define a runner ID](#define-a-runner-id)
- [Create a runner image](#create-a-runner-image)
- [Write a processor](#write-a-processor)
- [Write a smoke test](#write-a-smoke-test)

### Create a base image

The images of Runners inherit from our Docker base images on [sider/devon_rex](https://github.com/sider/devon_rex),
and each of them provides a specific programming environment (e.g., Ruby, Java, PHP, and so on).

You don't have to create a new base image in almost cases.
However, if your new runner requires a new programming environment,
you would have to get into building the new base image first.

### Define a runner ID

First, let's define an ID of the runner that you are going to support.
This ID will be used everywhere as a directory name, an image name, etc.

Please follow the naming rules below:

- Use only lowercase letters (`a-z`) and underscores (`_`), e.g. `foolint` or `foo_lint`.
- Make it simple and clear.

In the following examples, assume that the defined runner ID is `foolint`.

After defining a ID, you should add also metadata of the runner into [`analyzers.yml`](../analyzers.yml).

### Create a runner image

Next, let's create a Docker image for the runner.

For example, the `Dockerfile` location is `images/foolint/Dockerfile.erb`.
`images/foolint/Dockerfile` is generated automatically.

`.erb` is a file extension for [ERB](https://en.wikipedia.org/wiki/ERuby) which is a Ruby template engine.
See the official manual for more details about ERB.

In the `Dockerfile`, you will write the followings:

- Install the tool. (download, compile, and so on.)
- Install the tool's dependencies (libraries, plugins, and so on.) if needed.
- Setup the tool's default configuration file for Sider if needed.

### Write a processor

When you create a Docker image, let's write a processor code in Ruby.
This is the most important task in creating a new runner.

The processor code defines:

- the runner meta-information, e.g. the runner name
- the runner schema for `sider.yml` (the Sider's configuration file)
- how to run the tool
- how to process the tool's execution results

For example, you need to create a file named `lib/runners/processor/foolint.rb`,
and the file has the following content:

```ruby
# lib/runners/processor/foolint.rb
module Runners
  class Processor::Foolint < Processor
    Schema = StrongJSON.new do
      # define schemas...
    end

    def setup
      # write setup code if needed...
    end

    def analyze(changes)
      # write analyzing code
    end
  end
end
```

Also, do not forget to add the following to `lib/runners.rb`:

```ruby
# lib/runners.rb
require "runners/processor/foolint"
```

### Write a smoke test

We recommend writing also a smoke test during writing the processor.
Because the smoke test can emulate the runner behavior.

For example, you need to create a `test/smokes/foolint/expectations.rb` and add a smoke test case to the file:

```ruby
# test/smokes/foolint/expectations.rb
s = Runners::Testing::Smoke

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "foo.rb",
      location: { start_line: 81 },
      id: "foo-rule-1",
      message: "A violation is detected",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "foolint", version: "1.2.3" }
)
```

`"success"` in the example above points to `test/smokes/foolint/success/` directory.
Here is the directory structure:

```shell
$ tree -F test/smokes/foolint
test/smokes/foolint
├── expectations.rb
└── success/
    └── foo.rb

1 directory, 2 files
```

You should add new test cases as you progress in implementing the processor.

If you want to run the smoke test, run the following command:

```shell
$ bundle exec rake docker:build docker:smoke ANALYZER=foolint
```

See [this description](../README.md#testing), about the available `rake` commands.

## Open a pull request

If you are ready for a new runner, open a new pull request checking the followings:

- [ ] Add a new tool to [`analyzers.yml`](../analyzers.yml).
- [ ] Run `bundle exec rake readme:generate` and commit the updated [`README.md`](../README.md).
- [ ] Add a new tool to the [Dependabot configuration](../.github/dependabot.yml) if needed.
- [ ] Provide the tool's options that users can customize.
- [ ] Write smoke test cases. E.g. all options, successful end, warnings, errors, etc.
- [ ] Add a [CI setting](../.github/workflows/build.yml).
- [ ] Write a [document](https://github.com/sider/sider-docs) and link the pull request, e.g. `sider/sider-docs#789`
