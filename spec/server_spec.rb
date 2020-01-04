# frozen_string_literal: true

require 'json'
require 'rack/test'
require 'rspec'

require 'server'
require 'solaredge/api_helper'

ENV['RACK_ENV'] = 'test'

module AppMixin
  include Rack::Test::Methods
  class TestServer < Server
    set :se_api, SE::FakeSolaredgeApi.new
  end

  def app
    TestServer.new
  end
end

describe 'server testing' do
  include AppMixin

  it 'should return hello world' do
    get '/'

    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end

  it 'should return simple overview' do
    get '/v1/overview'

    expect(last_response).to be_ok
    expect(last_response.original_headers).to include(
      'Content-Type' => 'application/json'
    )

    result = JSON.parse(last_response.body)
    expect(result).to eq(
      'current_power' => 2000,
      'last_day_energy' => 3000,
      'last_month_energy' => 4000,
      'last_year_energy' => 5000,
      'lifetime_energy' => 6000,
      'update_time' => '2019-01-01T00:00:00+00:00'
    )
  end
end
