target :lib do
  signature "sig.new" # TODO: Rename to "sig"

  check "lib/runners/analyzer.rb"
  check "lib/runners/changes.rb"
  check "lib/runners/cli.rb"
  check "lib/runners/trace_writer.rb"
  check "lib/runners/options.rb"
  check "lib/runners/io.rb"

  # stdlib
  library "pathname"
  library "set"
  library "tmpdir"

  # 3rd-party
  library "jsonseq"
  library "strong_json"
end

# target :spec do
#   signature "sig", "sig-private"

#   check "spec"

#   # library "pathname", "set"       # Standard libraries
#   # library "rspec"
# end
