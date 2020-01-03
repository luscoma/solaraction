# frozen_string_literal: true

require 'solaredge/api'

module SE
  # A fake api helper that can be used for simple tests
  class FakeSolaredgeApi
    def site_overview
      SE::SiteOverview.new(
        current_power: 2000,
        last_day_energy: 3000,
        last_month_energy: 4000,
        last_year_energy: 5000,
        lifetime_energy: 6000,
        update_time: DateTime.parse('2019-01-01')
      )
    end
  end
end
