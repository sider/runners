namespace :dockerfile do
  desc 'Verify Dockerfile is committed'
  task :verify do
    sh 'git', 'diff', '--exit-code', 'images' do |ok|
      unless ok
        abort "\nError: Run `bundle exec rake dockerfile:generate` and include the changes in commit"
      end
    end
  end
end
