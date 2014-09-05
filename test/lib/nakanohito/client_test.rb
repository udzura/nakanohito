# -*- coding: utf-8 -*-
require 'test_helper'

class NakanohitoClientTest < ActiveSupport::TestCase
  def schedules
    Nakanohito::Schedules.new(config: <<-EOY.strip_heredoc)
      -
        text: Hello, post
        scheduled_at: 2014-09-05 12:30:00 +0900
      -
        text: Hello, post 2
        scheduled_at: 2014-09-06 12:30:00 +0900
      -
        text: 日本語の投稿。
        scheduled_at: 2014-09-07T12:30:00+0900
    EOY
  end

  def setup
    stub_request_on_create
    @test_target ||= Nakanohito::Client.new(schedules)
  end

  def stub_request_on_create
    stub_request(:get, "https://api.bufferapp.com/1/profiles.json?access_token=#{Nakanohito.config.access_token}").to_return(
      :status => 200,
      :body => %Q|[
        {"_id": "aaaaaaaaaaaa000000000000", "service": "facebook"},
        {"_id": "aaaaaaaaaaaa111111111111", "service": "twitter"}
      ]|,
      :headers => {'Content-Type' => 'application/json'}
    )
  end

  def stub_success_registration(text, scheduled_at)
    stub_request(:post, "https://api.bufferapp.com/1/updates/create.json?access_token=#{Nakanohito.config.access_token}").
      with(:body => {"profile_ids"=>[@test_target.profile_id], "scheduled_at"=>scheduled_at, "text"=>text}).
      to_return(
        :status => 200,
        :body => %Q|{"success": true}|,
        :headers => {'Content-Type' => 'application/json'}
      )
  end

  test 'client configured' do
    assert_equal   3, @test_target.schedules.size
    assert_kind_of Buff::Client, @test_target.client
    assert_equal   'aaaaaaaaaaaa111111111111', @test_target.profile_id
  end

  test 'updates successfully created' do
    stub_request(:get, "https://api.bufferapp.com/1/profiles/#{@test_target.profile_id}/updates/pending.json?access_token=#{Nakanohito.config.access_token}").
      to_return(
        :status => 200,
        :body => %Q|{"updates": []}|,
        :headers => {'Content-Type' => 'application/json'}
      )

    stub_success_registration "Hello, post",   "2014-09-05T12:30:00+09:00"
    stub_success_registration "Hello, post 2", "2014-09-06T12:30:00+09:00"
    stub_success_registration "日本語の投稿。", "2014-09-07T12:30:00+09:00"

    response = @test_target.register
    assert_equal 3, response.size
    assert response.all?{|v| v.success }
  end

  test 'updates successfully created and skips already registered' do
    stub_request(:get, "https://api.bufferapp.com/1/profiles/#{@test_target.profile_id}/updates/pending.json?access_token=#{Nakanohito.config.access_token}").
      to_return(
        :status => 200,
        :body => %Q|{"updates":
          [{"id": "deadbeaf", "scheduled_at": #{Time.parse("2014-09-06T12:30:00+09:00").to_i}}]
        }|,
        :headers => {'Content-Type' => 'application/json'}
      )

    stub_success_registration "Hello, post",   "2014-09-05T12:30:00+09:00"
    stub_success_registration "日本語の投稿。", "2014-09-07T12:30:00+09:00"

    response = @test_target.register
    assert_equal 2, response.size
    assert response.all?{|v| v.success }
  end
end
