module Nakanohito
end

require 'nakanohito/version'
require 'nakanohito/config'
require 'nakanohito/schedules'
require 'nakanohito/client'

if defined? Rails
  require 'nakanohito/railtie'
end

module Nakanohito
  def self.register!
    schedules = Schedules.new_from_rails_config
    client = Client.new(schedules)
    client.register.each do |response|
      if response.success
        updates = response.updates
        puts "OK: #{updates._id}"
        puts "#{updates.text} scheduled at #{Time.at(updates.scheduled_at)}"
      else
        puts "Something is wrong...: #{response.message}"
        puts "Original schedule is: #{response.original_schedule.inspect}"
      end
    end
  end
end
