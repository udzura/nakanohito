module Nakanohito
end

require 'nakanohito/version'
require 'nakanohito/config'
require 'nakanohito/parser'
require 'nakanohito/client'

if defined? Rails
  require 'nakanohito/railtie'
end
