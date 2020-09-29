module Runners
  module RecommendedConfig
    def warn_recommended_config_file_release(config_filename, release_date)
      add_warning <<~MSG, file: config_filename
        Sider's recommended configuration file is about to release in #{release_date}.
        After the release, Sider will automatically apply our recommended set of rules if you don't have the #{analyzer_name} configuration file called #{config_filename} in your repository.
      MSG
    end

    def prepare_config_file(config_filename)
      user_config_filepath = current_dir / config_filename
      recommended_config_filepath = Pathname(Dir.home) / "sider_recommended_#{config_filename}"

      if user_config_filepath.exist?
        trace_writer.message "The #{analyzer_name} configuration file called #{config_filename} exists in the root directory of your repository. The Sider's recommended set of rules is ignored."
        return
      end

      if config_linter[:filter]
        trace_writer.message "The `filter` option in #{config.path_name} is specified. The Sider's recommended set of rules is ignored."
        return
      end

      trace_writer.message "The #{analyzer_name} configuration file called #{config_filename} does not exist in the root directory of your repository. Sider uses our recommended set of rules instead."
      FileUtils.copy(recommended_config_filepath, user_config_filepath)
    end
  end
end
