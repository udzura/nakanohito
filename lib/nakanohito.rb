module Nakanohito
end

require 'nakanohito/version'
require 'nakanohito/config'
require 'nakanohito/schedules'
require 'nakanohito/client'

if defined? Rails
  require 'nakanohito/railtie'
end
