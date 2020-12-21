namespace :steep do
  desc "Show the Steep coverage report"
  task :stats do
    sh "bundle exec steep stats --log-level=fatal | column -s, -t | sort --key=7 --sort=numeric"
  end
end
