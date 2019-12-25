# frozen_string_literal: true

require 'solaredge/api_data'
require 'solaredge/url_mixin'

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
end
