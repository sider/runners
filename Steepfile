target :lib do
  # TODO: Rename to `sig` when the migration will complete.
  signature "sig_new"

  check "lib/runners.rb"
  check "lib/runners/analyzer.rb"
  check "lib/runners/cli.rb"
  check "lib/runners/config.rb"
  check "lib/runners/errors.rb"
  # check "lib/runners/ignoring.rb"
  check "lib/runners/shell.rb"
  # TODO: Add checking...

  # FIXME: Cannot resolve errors about `Struct`.
  ignore "lib/runners/options.rb"

  library "pathname"
  library "set"
  library "tmpdir"
end
