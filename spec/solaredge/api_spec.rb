# frozen_string_literal: true

require 'solaredge/api'
require 'solaredge/api_data'

describe SE::Api do
  before do
    SE::Api.class_eval do
      def self.get(url)
        url
      end
    end
  end

  subject { SE::Api.new(SE::ApiData.new('new', '1000')) }

  it 'fetches details' do
    expect(subject.site_details).to eq('/site/1000/details?api_key=new')
  end
end
