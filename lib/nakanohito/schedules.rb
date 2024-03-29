require 'yaml'
require 'active_support/core_ext/module/delegation'
require 'hashie/mash'

class Nakanohito::Schedules
  def self.new_from_rails_config
    new(file_path: Nakanohito.config.file_path)
  end

  # File format should be:
  #
  #     -
  #       text: This is a sample post!!!1
  #       scheduled_at: 2014-09-05 12:30:00 +0900
  #     -
  #       text: This is a more sample post!!!!!1
  #       scheduled_at: 2014-09-05 12:40:00 +0900
  #
  def initialize(file_path: nil, config: nil)
    yaml = if file_path
             File.read(file_path)
           else
             config
           end

    @config = YAML.load(yaml).map do |schedule|
      Hashie::Mash.new(schedule).tap do |vo|
        vo.scheduled_at_in_epoctime = vo.scheduled_at.to_i
      end
    end
  end
  attr_accessor :config
  delegate :[], :[]=, :size, :each, to: :config

  include Enumerable
end
