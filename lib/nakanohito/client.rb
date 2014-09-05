require 'nakanohito/schedules'
require 'buff'

class Nakanohito::Client
  def initialize(schedules)
    @schedules = schedules
    @client = Buff::Client.new(Nakanohito.config.access_token)
    @profile_id = Nakanohito.config.profile_id || default_profile_id
  end
  attr_accessor :schedules, :client, :profile_id

  def register
    register_response = []
    schedules.each do |schedule|
      next if already_registered.any? {|plan| plan.scheduled_at == schedule.scheduled_at_in_epoctime }
      res = create_update(schedule.text, schedule.scheduled_at)
      res.original_schedule = schedule
      register_response << res
    end
    register_response
  end

  def already_registered
    @already_registered ||= \
      begin
        if res = client.updates_by_profile_id(@profile_id, status: :pending)
          res.updates
        else
          []
        end
      end
  end
  private

  def create_update(text, scheduled_at)
    client.create_update(body: {
        text:         text,
        profile_ids:  [@profile_id],
        scheduled_at: scheduled_at.iso8601
      })
  end

  def default_profile_id
    twitter_profile = client.profiles.select{|p| p.service == 'twitter' }.first
    twitter_profile && twitter_profile._id
  end
end
