# -*- coding: utf-8 -*-
require 'test_helper'

class NakanohitoSchedulesTest < ActiveSupport::TestCase
  YAML_CONTENT = <<-EOY.strip_heredoc
    -
      text: Hello, post
      scheduled_at: 2014-09-05 12:30:00 +0900
    -
      text: Hello, post 2
      scheduled_at: 2014-09-06 12:30:00 +0900
    -
      text: 日本語の投稿。
      scheduled_at: 2014-09-07 12:30:00 +0900
  EOY

  test "schedule shuold parse YAML file" do
    @schedules = Nakanohito::Schedules.new(config: YAML_CONTENT)
    assert_kind_of Array, @schedules.config
    assert_equal 3, @schedules.size

    @first = @schedules[0]
    assert_equal "Hello, post", @first["text"]
    assert_equal Time.parse("2014-09-05 12:30:00 +0900"), @first["scheduled_at"]

    @third = @schedules[2]
    assert_equal "日本語の投稿。", @third["text"]
    assert_equal Time.parse("2014-09-07 12:30:00 +0900"), @third["scheduled_at"]
  end
end
