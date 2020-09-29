module Runners
  module RecommendedConfig
    # When the notification period expires, set `activate` to `true` to activate our default configuration file.
    # If it is `false`, this method just notifies release of it is approaching as a warning message.
    def deploy_recommended_config_file(activate, release_date, config_filename, skips=[])
      if activate
        deploy_file(config_filename, skips)
      else
        notify_release(config_filename, release_date)
      end
    end

    private

    def notify_release(config_filename, release_date)
      add_warning <<~MSG, file: config_filename
        Sider's recommended configuration file is about to release in #{release_date}.
        After the release, Sider will automatically apply our recommended set of rules if you don't have the #{analyzer_name} configuration file called #{config_filename} in your repository.
      MSG
    end

    def deploy_file(config_filename, skips)
      user_config_filepath = current_dir / config_filename
      recommended_config_filepath = Pathname(Dir.home) / "sider_recommended_#{config_filename}"

      skips.append([proc { user_config_filepath.exist? },
        "The #{analyzer_name} configuration file called #{config_filename} exists in the root directory of your repository. The Sider's recommended set of rules is ignored."])

      skips.each do |predict, msg|
        if predict.call()
          trace_writer.message msg
          return
        end
      end

      trace_writer.message "The #{analyzer_name} configuration file called #{config_filename} does not exist in the root directory of your repository. Sider uses our recommended set of rules instead."
      FileUtils.copy(recommended_config_filepath, user_config_filepath)
    end
  end
end
