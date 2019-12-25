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
    # TODO parametertize this
    def date_range
      add(startDate: '2019-12-23', endDate: '2019-12-24')
    end

    # TODO parametertize this
    def time_range
      add(startTime: '2019-12-23 12:00:00', endTime: '2019-12-24 00:00:00')
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
