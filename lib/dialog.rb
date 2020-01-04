# frozen_string_literal: true

require 'time'
require 'actionutil'

def dialog_overview(site_overview)
  builder = ActionUtil::ResponseBuilder.new
  builder.simple(
    display_text: "Your solar is currently producing #{site_overview.current_power} kw, today it produced #{site_overview.last_day_energy} kw/h, and this month it produced #{site_overview.last_month_energy} kw/h",
    speech_text: "Your solar is currently producing #{site_overview.current_power} kilowatts, today it produced #{site_overview.last_day_energy} kilowatt-hours, and this month it produced #{site_overview.last_month_energy} kilowatt-hours"
  )
  builder.suggestions(suggestions: ['More'])
end

def dialog_more(site_energy)
  # Cache bust the image value by creating a timestamp rounded to 1 min
  cache_bust_value = Time.now.to_i
  cache_bust_value -= cache_bust_value % 60

  builder = ActionUtil::ResponseBuilder.new
  builder.simple(
    display_text: "You have produced #{site_energy.energy} kw/h today",
    speech_text: "You have produced #{site_energy.energy} kilowatt-hours today"
  )
  builder.basic_card(
    title: 'Power Generation',
    subtitle: Date.today.strftime('%m-%d-%Y'),
    text: "You have produced #{site_energy.energy} kw/h today",
    image: ActionUtil.image(
      uri: "#{ENV['MY_BASE_URL']}/v1/power.png?b=#{cache_bust_value}",
      ally: 'Power usage over time'
    )
  )
end
