# frozen_string_literal: true

# A library to fetch data from the SolarEdge monitoring API
require 'httparty'
require 'solaredge/url_mixin'

module SE
  # API Helper class
  class Api
    include HTTParty
    include SE::UrlMixin
    base_uri 'https://monitoringapi.solaredge.com'

    # @return [SE::ApiData]
    attr_accessor :api_data

    # @param api_data [SE::ApiData] Api key and site id
    def initialize(api_data)
      @api_data = api_data
    end

    # Provides a site overview including energy usage over some preset
    # periods of time, including day, month, year, lifetime.
    def site_overview
      url = site 'overview'
      o = self.class.get(url.to_s)['overview']
      SiteOverview.new(
        current_power: o['currentPower']['power'],
        last_day_energy: o['lastDayData']['energy'],
        last_month_energy: o['lastMonthData']['energy'],
        last_year_energy: o['lastYearData']['energy'],
        lifetime_energy: o['lifeTimeData']['energy'],
        update_time: DateTime.parse(o['lastUpdateTime']))
    end

    # Returns fun facts about polution reduced e.g. light bulbs replaced and
    # CO2 not produced.
    def site_env_benefits
      url = site 'envBenefits'
      o = self.class.get(url.to_s)['envBenefits']
      EnvBenefits.new(
        kg_co2_saved: o['gasEmissionSaved']['co2'],
        trees_planted: o['treesPlanted'],
        lightbulbs_replaced: o['lightBulbs'])
    end

    # Returns amount of energy produced over a given date range
    # @param start_time [Date, nil]
    # @param end_time [Date, nil]
    def site_energy_over_time(start_date = nil, end_date = nil)
      url = site('timeFrameEnergy').date_range(start_date, end_date)
      o = self.class.get(url.to_s)['timeFrameEnergy']
      EnergyProduced.new(
        energy: o['energy'],
        start_date: Date.parse(o['startLifetimeEnergy']['date']),
        end_date: Date.parse(o['endLifetimeEnergy']['date'])
      )
    end

    # Returns power produced in 15 minute increments
    # @note Power is in instaneous watt's produced.
    # @param start_time [DateTime, nil]
    # @param end_time [DateTime, nil]
    def site_power(start_time = nil, end_time = nil)
      url = site('power').time_range(start_time, end_time)
      o = self.class.get(url.to_s)['power']
      o['values'].map do |v|
        # Note this DateTIme has no timezone value specified
        # The time is local to site's time zone
        PowerValue.new(date_time: DateTime.parse(v['date']),
                       value: v['value'])
      end
    end
  end

  # Helper structs for formatting data
  EnergyProduced = Struct.new(
    :energy, :start_date, :end_date, keyword_init: true)

  PowerValue = Struct.new(:date_time, :value, keyword_init: true)

  EnvBenefits = Struct.new(
    :kg_co2_saved, :trees_planted, :lightbulbs_replaced,
    keyword_init: true)

  SiteOverview = Struct.new(
    :current_power, :last_day_energy, :last_month_energy, :last_year_energy,
    :lifetime_energy, :update_time, keyword_init: true)

  # Add a to_json method that makes sense
  [EnergyProduced, PowerValue, EnvBenefits, SiteOverview].each do |c|
    c.class_eval do
      def to_json(*args)
        to_h.to_json(*args)
      end
    end
  end

end
