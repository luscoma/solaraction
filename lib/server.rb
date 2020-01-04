# frozen_string_literal: true

require 'gruff'
require 'time'
require 'sinatra/base'
require 'sinatra/json'

require 'actionutil'
require 'graphutil'

# Simple server
class Server < Sinatra::Base
  set :bind, '0.0.0.0'

  get '/' do
    'Hello World'
  end

  post '/dialogFulfillment' do
    payload = JSON.parse(request.body.read)
    intent = payload.dig('intent', 'displayName') || 'nil'
    overview = settings.se_api.site_energy_over_time

    # Cache bust the image value by creating a timestamp rounded to 1 min
    cache_bust_value = Time.now.to_i
    cache_bust_value -= cache_bust_value % 60

    builder = ActionUtil::ResponseBuilder.new
    builder.simple(
      display_text: "You have produced #{overview.energy} kw/h today",
      speech_text: "You have produced #{overview.energy} kilowatt-hours today"
    )
    builder.basic_card(
      title: 'Power Generation',
      subtitle: Date.today.strftime('%m-%d-%Y'),
      text: "You have produced #{overview.energy} kw/h today",
      image: ActionUtil.image(
        uri: "#{ENV['MY_BASE_URL']}/v1/power.png?b=#{cache_bust_value}",
        ally: 'Power usage over time'
      )
    )
    json builder
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
