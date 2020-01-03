# frozen_string_literal: true

require 'gruff'
require 'sinatra/base'
require 'sinatra/json'
require 'pry'

require 'graphutil'

# Simple server
class Server < Sinatra::Base
  set :bind, '0.0.0.0'

  get '/' do
    'Hello World'
  end

  get '/v1/overview' do
    json settings.se_api.site_overview
  end

  get '/v1/power.png' do
    power = settings.se_api.site_power
    labels, values = GraphUtil.make_power_graph_labels_and_values(power)
    g = GraphUtil.power_graph(Date.today, labels, values)

    content_type 'image/png'
    g.to_blob
  end
end
