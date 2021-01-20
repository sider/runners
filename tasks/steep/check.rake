namespace :steep do
  desc "Run type-check by Steep"
  task :check do
    # NOTE: Suppress too many log via `fatal` level.
    sh "bundle", "exec", "steep", "check", "--log-level=fatal"
  end
end
