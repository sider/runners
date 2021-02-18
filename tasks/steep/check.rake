namespace :steep do
  desc "Run type-check by Steep"
  task :check, [:save] do |_task, args|
    # @see https://github.com/soutaro/steep/pull/303
    opts = args[:save] ? ["--save-expectations"] : ["--with-expectations"]

    # NOTE: Suppress too many log via `fatal` level.
    sh "bundle", "exec", "steep", "check", "--log-level=fatal", *opts
  end
end
