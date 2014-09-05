require 'nakanohito/schedules'

class Nakanohito::Client
  def initialize(schedules)
    @schedules = schedules
  end
  attr_accessor :schedules
end
