> Explain a summary, purpose, or background for this change.

> Link related issues, e.g. "Fix #<ISSUE_ID>", "Related to #<ISSUE_ID>", or "None."

> Check the following items.

- [ ] Add a new [changelog](https://github.com/sider/runners/blob/master/CHANGELOG.md) entry if this change is notable.

When adding a new runner (remove the list if needless):

- [ ] Read and follow the [document](https://github.com/sider/runners/blob/master/docs/how-to-write-a-new-runner.md) for a new runner.
- [ ] Add a new tool to [`analyzers.yml`](https://github.com/sider/runners/blob/master/analyzers.yml).
- [ ] Run `bundle exec rake readme:generate` and commit the updated `README.md`.
- [ ] Add a new tool to [`.dependabot/config.yml`](https://github.com/sider/runners/blob/master/.dependabot/config.yml) if needed.
- [ ] Provide option(s) that users can customize.
- [ ] Write smoke test cases. E.g. all options, successful end, warnings, errors, etc.
- [ ] Add a [CI setting](https://github.com/sider/runners/blob/master/.github/workflows/build.yml).
- [ ] Write a [document](https://github.com/sider/sider-docs) and link the PR sider/sider-docs#<PULL_NUMBER>
