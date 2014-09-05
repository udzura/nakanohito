require 'active_support/configurable'

module Nakanohito
  include ActiveSupport::Configurable

  # Useful aliases
  class << self.config
    def buffer_access_token;     self.access_token    ; end
    def buffer_access_token=(v); self.access_token = v; end
  end
end
