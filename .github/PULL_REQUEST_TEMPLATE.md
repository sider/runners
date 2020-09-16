> Explain a summary, purpose, or background for this change.

<!-- E.g This change aims to fix... -->

> Link related issues or pull requests.

<!-- E.g. Fix #123, Related to #456, or None etc. -->

> Check the following items.

<!-- Please remove this section or items if needless. -->

- [ ] Add a new [changelog](https://github.com/sider/runners/blob/master/CHANGELOG.md) entry if this change is notable.

If you are adding a new runner:

- [ ] Read and follow the [document](https://github.com/sider/runners/blob/master/docs/how-to-write-a-new-runner.md) for a new runner.
- [ ] Add a new tool to [`analyzers.yml`](https://github.com/sider/runners/blob/master/analyzers.yml).
- [ ] Run `bundle exec rake readme:generate` and commit the updated `README.md`.
- [ ] Add a new tool to the [Dependabot configuration](https://github.com/sider/runners/blob/master/.github/dependabot.yml) if needed.
- [ ] Provide option(s) that users can customize.
- [ ] Write smoke test cases. E.g. all options, successful end, warnings, errors, etc.
- [ ] Add a [CI setting](https://github.com/sider/runners/blob/master/.github/workflows/build.yml).
- [ ] Write a [document](https://github.com/sider/sider-docs) and link the pull request, e.g. `sider/sider-docs#789`
