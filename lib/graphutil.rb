# frozen_string_literal: true

require 'gruff'

# Helpers for generating graphs
module GraphUtil
  # Applies a basic theme to a given graph
  # @param g [Gruff::Base] Graph
  def self.apply_theme(graph)
    graph.hide_legend = true
    graph.hide_dots = true
    graph.marker_font_size = 18
    graph.font = 'DejaVu-Sans'
    graph.theme = {
      colors: ['#aedaa9', '#12a702'],
      marker_color: '#dddddd',
      font_color: 'black',
      background_colors: 'white'
    }
  end

  # @param power [#value] List of power values
  # @param hours [Numeric>] Number of hours graph covers
  # @param hour_parts [Numeric] Number of hour subdivisions e.g. 4 for 15mins
  # @return [Array<Array>] Tuple of list of labels and values
  def self.make_power_graph_labels_and_values(power, hours: 24, hour_parts: 4)
    labels = (0...hours).to_a.each_with_object({}) do |hour, hash|
      hash[hour * hour_parts] = hour
    end
    power_values = power.map do |v|
      v.value.nil? ? 0 : v.value
    end
    # Ensure our array is always at least 24 hours * 4 long
    power_values.concat(
      (power_values.size...hours * hour_parts).to_a.map { 0 }
    )
    [labels, power_values]
  end

  # @param date [Date] Date graph covers
  # @param labels [Hash<Numeric, String>] Date graph covers
  # @param values [Array<Numeric>] Date graph covers
  # @return [Gruff::Line] Formatted power graph
  def self.power_graph(date, labels, values)
    g = Gruff::Line.new
    g.title = "Power Over Time: #{date}"
    apply_theme(g)
    g.labels = labels
    g.data 'Power', values
    g.minimum_value = 0
    g.maximum_value = 6_500 # should be configurable
    g
  end
end
