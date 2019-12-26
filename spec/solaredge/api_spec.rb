# frozen_string_literal: true

require 'solaredge/api'
require 'solaredge/api_data'

describe SE::Api do

  def setup_response golden_file
    data = File.read("#{__dir__}/goldens/#{golden_file}")
    allow(SE::Api).to receive(:get).and_return(JSON.parse(data))
  end

  subject { SE::Api.new(SE::ApiData.new('new', '1000')) }

  it 'fetches and parses the overview' do
    setup_response 'site_overview.json'
    expected = SE::SiteOverview.new(
      current_power: 85.405,
      last_day_energy: 6350.0,
      last_month_energy: 187_334.0,
      last_year_energy: 187_334.0,
      lifetime_energy: 268_156.0,
      update_time: DateTime.parse('2019-12-25 15:42:54')
    )
    expect(subject.site_overview).to eq(expected)
  end

  it 'fetches and parses site env benefits' do
    setup_response 'site_env_benefits.json'
    expected = SE::EnvBenefits.new(
      kg_co2_saved: 188.48625,
      trees_planted: 10.4565,
      lightbulbs_replaced: 812.47577
    )
    expect(subject.site_env_benefits).to eq(expected)
  end

  it 'fetches and parses site power' do
    setup_response 'site_power.json'
    expected = [
      SE::PowerValue.new(
        date_time: DateTime.parse('2019-12-23 13:15:00'), value: nil),
      SE::PowerValue.new(
        date_time: DateTime.parse('2019-12-23 13:30:00'), value: 4024.957),
      SE::PowerValue.new(
        date_time: DateTime.parse('2019-12-23 13:45:00'), value: 3673.22),
      SE::PowerValue.new(
        date_time: DateTime.parse('2019-12-23 14:00:00'), value: 3439.1726),
      SE::PowerValue.new(
        date_time: DateTime.parse('2019-12-23 14:15:00'), value: 3189.4937),
      SE::PowerValue.new(
        date_time: DateTime.parse('2019-12-23 14:30:00'), value: 0.0),
      SE::PowerValue.new(
        date_time: DateTime.parse('2019-12-23 14:45:00'), value: nil)
    ]
    expect(subject.site_power).to eq(expected)
  end

  it 'fetches and parses site energy over time' do
    setup_response 'site_energy_over_time.json'
    expected = SE::EnergyProduced.new(
      energy: 16_295.969,
      start_date: Date.parse('2019-12-22'),
      end_date: Date.parse('2019-12-23')
    )
    expect(subject.site_energy_over_time).to eq(expected)
  end
end
