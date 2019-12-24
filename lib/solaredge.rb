# frozen_string_literal: true

# Library to fetch information from the solar edge library
module SE
  require 'json'

  class InvalidApiData < StandardError
  end

  # Class that holds apikey and site id
  class ApiData
    attr_accessor :api_key, :site_id

    # @param fname [string] Filename of the jsonfile
    # @return [ApiData]
    def self.from_file(fname)
      data = JSON.parse(File.read(fname))
      new(data['apiKey'], data['siteId'])
    end

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
