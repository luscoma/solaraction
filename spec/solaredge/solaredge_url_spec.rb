# frozen_string_literal: true

require 'solaredge/api_data'
require 'solaredge/url_mixin'
require 'rspec/expectations'
require 'timecop'

RSpec::Matchers.define :have_params do |expected|
  match do |actual|
    q = actual.to_uri.query
    params = CGI.parse q

    expected.each.all? do |key, value|
      false unless params.key? key
      params[key][0] == value
    end
  end
  description do
    "have a query param #{query}=#{value}"
  end
  failure_message do |actual|
    q = actual.to_uri.query
    params = CGI.parse q
    # Filter to keys or values we can't find
    missing = expected.each.filter do |key, value|
      false if params.key? key
      params[key][0] != value
    end
    "expected that #{actual} would have query params #{missing}"
  end
end

describe SE::UrlMixin do
  class TestBuilder
    include SE::UrlMixin

    attr_accessor :api_data
    def initialize
      @api_data = SE::ApiData.new 'key', '1000'
    end
  end

  subject { TestBuilder.new }

  it 'creates arbitrary url' do
    expect(subject.url('/base').to_s).to eq('/base?api_key=key')
  end

  it 'creates site url with no subpath' do
    expect(subject.site .to_s).to eq('/site/1000?api_key=key')
  end

  it 'creates site url with subpath' do
    expect(subject.site('testing').to_s).to eq('/site/1000/testing?api_key=key')
    expect(subject.site('/testing').to_s).to eq(
      '/site/1000/testing?api_key=key')
  end

  it 'properly mixes in url helpers' do
    expect(subject.url('/base').noop.append('sub').noop .to_s).to eq(
      '/base/sub?api_key=key')
  end

  context 'using default times' do
    before { Timecop.freeze(2019, 6, 4) }
    after { Timecop.return }

    it 'date range properly defaults' do
      expect(subject.url('/base').date_range(nil, nil)).to have_params(
        'startDate' => '2019-06-04',
        'endDate' => '2019-06-05'
      )
    end
    it 'time range range properly defaults' do
      expect(subject.url('/base').time_range(nil, nil)).to have_params(
        'startTime' => '2019-06-04 00:00:00',
        'endTime' => '2019-06-05 00:00:00'
      )
    end
  end

  context 'using specific times' do
    let(:start_time) { DateTime.new(2019, 3, 3, 1, 30) }
    let(:end_time) { DateTime.new(2019, 3, 5, 1, 30) }

    it 'date range uses passed in values' do
      expect(subject.url('/base').date_range(
        start_time.to_date, end_time.to_date)).to have_params(
          'startDate' => '2019-03-03',
          'endDate' => '2019-03-05')
    end
    it 'time range uses passed in values' do
      expect(subject.url('/base').time_range(
        start_time, end_time)).to have_params(
          'startTime' => '2019-03-03 01:30:00',
          'endTime' => '2019-03-05 01:30:00')
    end
  end
end
