# frozen_string_literal: true

require 'actionutil'

describe ActionUtil do
  def golden(golden_file)
    data = File.read("#{__dir__}/goldens/#{golden_file}")
    JSON.parse(data)
  end

  subject { ActionUtil::ResponseBuilder.new }

  it 'is a well-formed empty object' do
    expect(subject.to_h).to eq('fulfillmentMessages' => [])
  end

  it 'generates simple response' do
    subject.simple(display_text: 'displayed')
    expect(subject.to_h).to eq(golden('simple_response.json'))
    subject.simple(display_text: 'displayed', speech_text: 'ally')
    expect(subject.to_h).to eq(golden('simple_response_with_ally.json'))
  end

  it 'generates basic card' do
    subject.basic_card(
      title: 'title',
      subtitle: 'subtitle',
      text: 'text'
    )
    expect(subject.to_h).to eq(golden('basic_card.json'))
  end

  it 'generates basic card with image' do
    subject.basic_card(
      title: 'title',
      subtitle: 'subtitle',
      text: 'text',
      image: ActionUtil.image(uri: 'http://uri.com')
    )
    expect(subject.to_h).to eq(golden('basic_card_with_image.json'))
  end

  it 'generates suggestions' do
    subject.suggestions(suggestions: ['alex', 'lusco'])
    expect(subject.to_h).to eq(golden('suggestions.json'))
  end

  it 'creates an image' do
    img = ActionUtil.image(uri: 'url', ally: 'ally')
    expect(img).to eql(
      'imageUri' => 'url',
      'accessibilityText' => 'ally'
    )
  end
end
