# frozen_string_literal: true

require 'solaredge'

describe SE::ApiData do

  subject { SE::ApiData.new 'key', 'site' }

  TEST_JSON = '{"apiKey": "test_key", "siteId": "test_site"}'

  it 'loads api data from json' do
    allow(File).to receive(:read).and_return(TEST_JSON)
    data = SE::ApiData.from_file('whatever.json')
    expect(data.api_key).to eq('test_key')
    expect(data.site_id).to eq('test_site')
  end

  it 'raises if there is no api key' do
    expect { SE::ApiData.new nil, nil }.to raise_error(
      SE::InvalidApiData)
  end
  it 'raises if there is no site id' do
    expect { SE::ApiData.new 'apikey', nil }.to raise_error(
      SE::InvalidApiData)
  end

  it 'is frozen' do
    expect(subject.frozen?).to be_truthy
  end

  it 'exposes properties' do
    expect(subject.api_key).to be('key')
    expect(subject.site_id).to be('site')
  end
end
