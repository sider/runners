module Runners
  module RecommendedConfig
    def deploy_recommended_config_file(config_filename)
      if exists_in_repository?(config_filename)
        trace_writer.message "The #{analyzer_name} configuration file called `#{config_filename}` exists in your repository. The Sider's recommended ruleset is ignored."
        return
      end

      trace_writer.message "The #{analyzer_name} configuration file called `#{config_filename}` does not exist in your repository. Sider uses our recommended ruleset instead."
      FileUtils.copy_file(Pathname(Dir.home) / "sider_recommended_#{config_filename}", current_dir / config_filename)
    end

    private

    def exists_in_repository?(filename)
      Dir.glob("**/#{filename}", File::FNM_DOTMATCH, base: working_dir.to_path).any?
    end
  end
end
