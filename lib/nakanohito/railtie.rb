require 'rails/railtie'

module Nakanohito
  Config = ::ActiveSupport::Configurable::Configuration
  class Railtie < ::Rails::Railtie
    initializer 'nakanohito.config_set_default' do
      Nakanohito.config.file_path ||= Rails.root.join("config", "nakanohito.yml")
    end

    rake_tasks do
      load "tasks/nakanohito_tasks.tasks"
    end

    config.to_prepare do
      unless Nakanohito.config.access_token
        raise "Nakanohito.config.access_token should be set in initializer"
      end

      unless Nakanohito.config.profile_id
        raise "Nakanohito.config.profile_id should be set in initializer"
      end
    end
  end
end
