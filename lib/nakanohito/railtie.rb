require 'rails/railtie'

module Nakanohito
  Config = ::ActiveSupport::Configurable::Configuration
  class Railtie < ::Rails::Railtie
    initializer 'nakanohito.config_validation' do
      unless Nakanohito.config.access_token
        raise "Nakanohito.config.access_token should be set in initializer"
      end
    end

    rake_tasks do
      load "tasks/nakanohito_tasks.tasks"
    end
  end
end
