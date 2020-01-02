#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'solaredge/api'
require 'solaredge/api_data'

API_OBJ = SE::Api.new SE::ApiData.from_file('./apikey.json')

get '/' do
  'Hello World'
end

get '/v1/overview' do
  json API_OBJ.site_overview
end
