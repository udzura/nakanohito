require 'active_support/configurable'

module Nakanohito
  include ActiveSupport::Configurable

  # Useful aliases
  class << self.config
    def buffer_access_token;     self.access_token    ; end
    def buffer_access_token=(v); self.access_token = v; end

    def buffer_profile_id;       self.profile_id      ; end
    def buffer_profile_id=(v);   self.profile_id = v  ; end
  end
end
