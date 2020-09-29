module Runners
  module RecommendedConfig
    def warn_recommended_config_file_release
      add_warning <<~MSG, file: 'CPPLINT.cfg'
        Sider's recommended configuration file is about to release in mid October 2020.
        After the release, Sider will automatically apply our recommended set of rules if you don't have the cpplint configuration file called CPPLINT.cfg in your repository.
      MSG
    end

    def prepare_config_file
      user_config_filepath = current_dir / 'CPPLINT.cfg'
      recommended_config_filepath = Pathname(Dir.home) / 'sider_recommended_CPPLINT.cfg'

      if user_config_filepath.exist?
        trace_writer.message "The cpplint configuration file called CPPLINT.cfg exists in the root directory of your repository. The Sider's recommended set of rules is ignored."
        return
      end

      if config_linter[:filter]
        trace_writer.message "The `filter` option in #{config.path_name} is specified. The Sider's recommended set of rules is ignored."
        return
      end

      trace_writer.message "The cpplint configuration file called CPPLINT.cfg does not exist in the root directory of your repository. Sider uses our recommended set of rules instead."
      FileUtils.copy(recommended_config_filepath, user_config_filepath)
    end
  end
end
