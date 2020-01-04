# frozen_string_literal: true

require 'gruff'
require 'time'
require 'sinatra/base'
require 'sinatra/json'

require 'graphutil'
require 'dialog'

# Simple server
class Server < Sinatra::Base
  set :bind, '0.0.0.0'

  get '/' do
    'Hello World'
  end

  post '/dialogFulfillment' do
    payload = JSON.parse(request.body.read)
    intent = payload.dig('queryResult', 'intent', 'displayName') || 'overview'

    result = case intent
             when 'More'
               energy = settings.se_api.site_energy_over_time
               dialog_more(energy)
             else
               overview = settings.se_api.site_overview
               dialog_overview(overview)
             end
    json result
  end

  get '/v1/overview' do
    json settings.se_api.site_overview
  end

  get '/v1/power.png' do
    power = settings.se_api.site_power
    labels, values = GraphUtil.make_power_graph_labels_and_values(power)
    g = GraphUtil.power_graph(Date.today, labels, values)

    content_type 'image/png'
    cache_control private: true, max_age: 60
    g.to_blob
  end
end
