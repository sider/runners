# https://github.com/rubocop/rubocop/issues/8674

Rails.backtrace_cleaner.remove_silencers! if ENV['CI']
