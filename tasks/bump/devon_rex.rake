namespace :bump do
  desc 'Bump up all devon_rex images'
  task :devon_rex, [:next_version] do |_task, args|
    next_version = args.fetch(:next_version, 'master')

    puts "Bumping all devon_rex images to #{next_version}..."

    pattern = %r{^FROM sider/devon_rex_(.+):([a-z0-9\.]+)}
    current_version = nil

    Dir['images/**/*.erb'].sort.each do |file|
      content = File.read(file)
      content.match(pattern) do |m|
        new_content = content.gsub(pattern, "FROM sider/devon_rex_\\1:#{next_version}")
        if content != new_content
          File.write(file, new_content)
          puts "--> Updated: #{file}"
          _, current_version = m.captures
        end
      end
    end

    unless current_version
      puts "--> No changes."
      next
    end

    Rake::Task["dockerfile:generate"].invoke
    puts ""

    sh "git", "checkout", "-B", "bump_devon_rex_#{current_version}_to_#{next_version}"
    sh "git", "add", "images/"
    sh "git", "commit", "--message", <<~MSG
      Bump devon_rex images from #{current_version} to #{next_version}

      Via:
      ```
      $ bundle exec rake dockerfile:bump_devon_rex'[#{next_version}]'
      ```

      See also:
      - https://github.com/sider/devon_rex/releases/tag/#{next_version}
      - https://github.com/sider/devon_rex/blob/#{next_version}/CHANGELOG.md
    MSG

    Rake::Task["dockerfile:verify"].invoke
  end
end
