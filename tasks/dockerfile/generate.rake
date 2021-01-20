def render_erb(file, analyzer: ENV.fetch('ANALYZER'))
  locals = {
    analyzer: analyzer,
    chown: '${RUNNER_USER}:${RUNNER_GROUP}',
  }

  res = ERB.new(File.read(file), trim_mode: "<>").result_with_hash(locals)
  "\n#{res.strip}\n" # Ensure to start with one newline and end with one newline
end

namespace :dockerfile do
  desc 'Generate Dockerfile from a template'
  task :generate do
    Pathname.glob("images/*").filter(&:directory?).sort.each do |analyzer_dir|
      analyzer = analyzer_dir.basename.to_path
      backup_analyzer = ENV['ANALYZER']
      ENV['ANALYZER'] = analyzer

      content = <<~EOD
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        # NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
        # PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
        # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        #{render_erb(analyzer_dir / 'Dockerfile.erb', analyzer: analyzer).strip}
      EOD
      (analyzer_dir / 'Dockerfile').write(content)
    ensure
      if backup_analyzer
        ENV['ANALYZER'] = backup_analyzer
      else
        ENV.delete 'ANALYZER'
      end
    end
  end
end
