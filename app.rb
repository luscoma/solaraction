#!/usr/bin/env ruby
# frozen_string_literal: true

require 'server'
require 'solaredge/api'
require 'solaredge/api_data'

api_data = ENV['SE_API_DATA']

data = if !api_data.nil?
         SE::ApiData.from_json(api_data)
       else
         # Fallback for development
         SE::ApiData.from_file('./apikey.json')
       end

api = SE::Api.new data
Server.run! 'se_api' => api
