namespace :dockerfile do
  desc 'Verify the devon_rex image tag'
  task :verify_devon_rex do
    disallowed_tag = 'master'
    sh 'git', 'grep', '--quiet', "/devon_rex_.+:#{disallowed_tag}", 'images/' do |found|
      if found
        abort "\nError: Disallow to release with the `#{disallowed_tag}` tag of the devon_rex images."
      end
    end
  end
end
