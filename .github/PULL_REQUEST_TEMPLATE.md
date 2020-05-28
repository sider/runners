> Explain a summary, purpose, or background for this change.

> Link related issues, e.g. "Fix #<ISSUE_ID>", "Related to #<ISSUE_ID>", or "None."

> Check the following items when adding a new runner. Otherwise, remove this section and list.

- [ ] Read and follow the [document](https://github.com/sider/runners/blob/master/docs/how-to-write-a-new-runner.md) for a new runner.
- [ ] Add a new tool to [`analyzers.yml`](https://github.com/sider/runners/blob/master/analyzers.yml).
- [ ] Run `bundle exec rake readme:generate` and commit the updated `README.md`.
- [ ] Add a new tool to [`.dependabot/config.yml`](https://github.com/sider/runners/blob/master/.dependabot/config.yml).
- [ ] Provide option(s) that users can customize.
- [ ] Write smoke test cases with enough coverage. E.g. all options, successful end, warnings, errors, etc.
- [ ] Add a [CI setting](https://github.com/sider/runners/blob/master/.github/workflows/build.yml).
- [ ] Add a new [changelog](https://github.com/sider/runners/blob/master/CHANGELOG.md) entry.
- [ ] Write a [document](https://github.com/sider/sider-docs) for the new runner. PR sider/sider-docs#<PULL_NUMBER>
