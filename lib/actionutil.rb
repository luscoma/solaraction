# frozen_string_literal: true

# Utils for working with actions on Google
module ActionUtil
  # A builder for actions on google responses
  class ResponseBuilder
    # @return [Hash]
    attr_reader :obj
    # @return [Array]
    attr_reader :messages

    def initialize
      @messages = []
      @obj = { 'fulfillmentMessages' => @messages }
    end

    # Builds a simple text response
    # @param display_text [String]
    # @param speech_text [String, nil] Defaults to display_text
    # @return [ResponseBuilder]
    def simple(display_text:, speech_text: nil)
      o = find_or_create('simpleResponses')
      result = { 'displayText' => display_text }
      result['textToSpeech'] = speech_text unless speech_text.nil?
      # Yes it's double nested, blame google...
      o['simpleResponses'] = { 'simpleResponses' => [result] }
      self
    end

    # Builds a simple text response
    # @param title [String]
    # @param subtitle [String]
    # @param text [String]
    # @param image [Hash, nil]
    # @return [ResponseBuilder]
    def basic_card(title:, subtitle:, text:, image: nil)
      o = find_or_create('basicCard')
      result = {
        'title' => title,
        'subtitle' => subtitle,
        'formattedText' => text
      }
      result['image'] = image unless image.nil?
      o['basicCard'] = result
      self
    end

    # @param suggestions [Array<String>]
    # @return [ResponseBuilder]
    def suggestions(suggestions:)
      o = find_or_create('suggestions')
      o['suggestions'] = {
        'suggestions' => suggestions.map { |v| { 'title' => v } }
      }
      self
    end

    # @return [Hash]
    def to_h
      @obj
    end

    # @return [Array]
    def to_a
      @messages
    end

    # @return [String]
    def to_json(*args)
      to_h.to_json(*args)
    end

    private

    def find_or_create(key)
      existing = @messages.find_index { |v| v.key?(key) }
      if existing.nil?
        o = { 'platform' => 'ACTIONS_ON_GOOGLE', key => {} }
        @messages.append(o)
        o
      else
        @messages[existing]
      end
    end
  end

  # Creates an image object
  # @param uri [String] The uri to the image
  # @param ally [String, nil] The ally text or empty
  # @return [Hash]
  def self.image(uri:, ally: nil)
    result = { 'imageUri' => uri }
    result['accessibilityText'] = ally unless ally.nil?
    result
  end
end
