# frozen_string_literal: true

# A library to build URLs for solar edge with helpers
require 'iri'

module SE
  # Mixins to create urls for solaredge monitoring api paths
  # Expects a instance attribute called `api_data`
  module UrlMixin
    # Returns a site specific API sub-path
    # @param subpath [String, nil] a subpath to fetch
    # @return [SEUrlBuilderInterface] A url preset with the site's id
    def site(subpath = nil)
      base = url('/site').append(@api_data.site_id)
      if subpath
        subpath = subpath.delete_prefix '/'
        base = base.append(subpath)
      end
      base
    end

    # Creates a new url builder the solaredge API key attached
    # @return [SEUrlBuilderInterface] A url of path with the api key attached.
    def url(path)
      builder = Iri.new(path).add(api_key: @api_data.api_key)
      builder.extend IriHelpers
      builder
    end
  end

  # Solaredge API parameter helpers that are mixed into Iri
  module IriHelpers
    TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

    # @param start_date [Date, nil] Defaults to yesterday
    # @param end_date [Date, nil] Defaults to today
    def date_range(start_date, end_date)
      start_date ||= Date.today
      end_date ||= Date.today + 1
      add(startDate: start_date.to_s, endDate: end_date.to_s)
    end

    # @param start_time [DateTime, nil] Defaults to today midnight.
    # @param end_time [DateTime, nil] Defaults to tomorrow midnight.
    def time_range(start_time, end_time)
      start_time ||= Date.today.to_datetime
      end_time ||= (Date.today + 1).to_datetime
      add(
        startTime: start_time.strftime(TIME_FORMAT),
        endTime: end_time.strftime(TIME_FORMAT))
    end

    # Does nothing, useful for testing
    def noop
      self
    end

    # Wraps Iri.modify to always ensure our helpers are always mixed-in
    # Hard to do much better since Iri.modify calls Iri.new directly
    def modify
      result = super
      result.extend IriHelpers
      result
    end
  end

  # Unused except for documentation purposes
  class SEUrlBuilderInterface < Iri
    include IriHelpers
  end
end
