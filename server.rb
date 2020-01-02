#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'solaredge/api'
require 'solaredge/api_data'

@api = SE::Api.new SE::ApiData.from_file('./apikey.json')

get '/' do
  { 'test' => 'Hello World' }.to_json
end
