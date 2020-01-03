# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/json'
require 'pry'

# Simple server
class Server < Sinatra::Base
  get '/' do
    'Hello World'
  end

  get '/v1/overview' do
    json settings.se_api.site_overview
  end
end
