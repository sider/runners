> Explain a summary, purpose, or background for this change.

> Add related issues if they exist, e.g. "Fix #<ISSUE_ID>" or "Related to #<ISSUE_ID>"

> Check the following items if adding a new runner. Otherwise, remove the list.

- [ ] Read and follow the [document](https://github.com/sider/runners/blob/master/docs/how-to-write-a-new-runner.md) for a new runner.
- [ ] Add a new tool to [`analyzers.yml`](https://github.com/sider/runners/blob/master/analyzers.yml).
- [ ] Add a new tool to [`.dependabot/config.yml`](https://github.com/sider/runners/blob/master/.dependabot/config.yml).
- [ ] Provide option(s) that users can customize.
- [ ] Write smoke test cases with enough coverage. E.g. all options, successful end, warnings, errors, etc.
- [ ] Add a [CI setting](https://github.com/sider/runners/blob/master/.github/workflows/build.yml).
- [ ] Add a new [changelog](https://github.com/sider/runners/blob/master/CHANGELOG.md) entry.
- [ ] Write a [document](https://github.com/sider/sider-docs) for the new runner. PR sider/sider-docs#<PULL_NUMBER>
