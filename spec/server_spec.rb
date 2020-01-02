# frozen_string_literal: true

require 'rack/test'
require 'rspec'
require 'server'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

RSpec.configure { |c| c.include RSpecMixin }

describe 'server testing' do
  it 'should return hello world' do
    get '/'

    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end

  it 'should return simple overview' do
    get '/v1/overview'

    expect(last_response).to be_ok
    expect(last_response.original_headers).to include(
      'Content-Type' => 'application/json')
    expect(last_response.body).to eq('
      {"current_power":1980.8346,"last_day_energy":23638.0,"last_month_energy":39970.0,"last_year_energy":39970.0,"lifetime_energy":441110.0,"update_time":"2020-01-02T15:28:40+00:00"}')
  end
end
