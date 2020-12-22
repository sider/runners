namespace :rbs do
  desc "Update `ruby/gem_rbs` Git submodule"
  task :update_gems do
    root_dir = File.join(__dir__, "..", "..")
    Dir.chdir(root_dir)

    submodule_dir = File.join(root_dir, "vendor", "rbs", "gem_rbs")
    Dir.chdir(submodule_dir) do
      sh "git", "pull", "--rebase", "origin", "main"
    end

    sh "git", "submodule", "status"
  end
end
