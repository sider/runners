module Runners
  module RecommendedConfig
    def warn_recommended_config_file_release(config_filename, release_date)
      add_warning <<~MSG, file: config_filename
        Sider's recommended configuration file is about to release in #{release_date}.
        After the release, Sider will automatically apply our recommended set of rules if you don't have the #{analyzer_name} configuration file called #{config_filename} in your repository.
      MSG
    end

    def deploy_recommended_config_file(config_filename)
      if exists_in_repository?(config_filename)
        trace_writer.message "The #{analyzer_name} configuration file called #{config_filename} exists in your repository. The Sider's recommended set of rules is ignored."
        return
      end

      trace_writer.message "The #{analyzer_name} configuration file called #{config_filename} does not exist in your repository. Sider uses our recommended set of rules instead."
      FileUtils.copy(Pathname(Dir.home) / "sider_recommended_#{config_filename}", current_dir / config_filename)
    end

    private

    def exists_in_repository?(config_filename)
      Dir.glob("**/#{config_filename}", File::FNM_DOTMATCH, base: working_dir).any?
    end
  end
end
