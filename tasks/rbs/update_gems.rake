namespace :rbs do
  desc "Update `ruby/gem_rbs_collection` Git submodule"
  task :update_gems do
    Dir.chdir "vendor/rbs/gem_rbs_collection" do |dir|
      sh "git", "pull", "--rebase", "origin", "main"
    end

    sh "git", "submodule", "status"
  end
end
