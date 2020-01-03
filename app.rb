#!/usr/bin/env ruby
# frozen_string_literal: true

require 'server'
require 'solaredge/api'
require 'solaredge/api_data'

api = SE::Api.new SE::ApiData.from_file('./apikey.json')
Server.run! 'se_api' => api
