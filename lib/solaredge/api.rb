# frozen_string_literal: true

# A library to fetch data from the SolarEdge monitoring API
require 'httparty'
require 'iri'
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

    # Returns the site details for this solaredge site
    def site_details
      url = site 'details'
      self.class.get(url.to_s)
    end

    # TODO make all these methods useful and have real return values
    def site_energy
      url = site 'energy'
      url = Util::date_range(url)
      url = url.add(timeUnit: 'HOUR')
      self.class.get(url.to_s)
    end

    def site_energy_over_time
      url = site 'timeFrameEnergy'
      url = Util::date_range(url)
      self.class.get(url.to_s)
    end

    def site_power
      url = site 'power'
      url = Util::time_range(url)
      self.class.get(url.to_s)
    end

    def site_overview
      url = site 'overview'
      self.class.get(url.to_s)
    end

    def site_power_detailed
      url = site 'powerDetails'
      url = Util::time_range(url)
      self.class.get(url.to_s)
    end

    def site_power_flow
      url = site 'currentPowerFlow'
      self.class.get(url.to_s)
    end

    def site_env_benefits
      url = site 'envBenefits'
      self.class.get(url.to_s)
    end

    def site_inventory
      url = site 'inventory'
      self.class.get(url.to_s)
    end
  end

end
