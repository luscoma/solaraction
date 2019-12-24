# frozen_string_literal: true

# Library to fetch information from the solar edge library
module SE
  require 'json'

  # Indicates incomplete or invalid API data
  class InvalidApiData < StandardError
  end

  # Class that holds apikey and site id
  class ApiData
    # @return [String] The API key to use
    attr_accessor :api_key
    # @return [String] The site id to query
    attr_accessor :site_id

    # Loads data from a JSON file.
    # @note Expected to have "apiKey" and "siteId" keys.
    # @param fname [string] Filename of the jsonfile
    # @return [ApiData]
    def self.from_file(fname)
      data = JSON.parse(File.read(fname))
      new(data['apiKey'], data['siteId'])
    end

    # @param api_key [String] The API Key
    # @param site_id [String] The site id
    def initialize(api_key, site_id)
      raise InvalidApiData, 'Missing Api Key' unless api_key
      raise InvalidApiData, 'Missing Site Id' unless site_id

      @api_key = api_key
      @site_id = site_id
      freeze
    end
  end
end

if $PROGRAM_NAME == __FILE__
  if ARGV.empty?
    p 'Too few arguments'
    exit
  end
  # Just display an API key
  key = SE::ApiData.from_file ARGV[0]
  p "API Key: #{key.api_key}"
  p "Site Id: #{key.site_id}"
end
