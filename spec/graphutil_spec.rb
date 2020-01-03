# frozen_string_literal: true

require 'rspec'

require 'graphutil'

FakeValue = Struct.new(:value)

describe 'graphutil test' do
  it 'generates proper labels' do
    labels, = GraphUtil.make_power_graph_labels_and_values([])
    expect(labels).to include(
      0 => 0,
      4 => 1,
      8 => 2,
      12 => 3,
      88 => 22,
      92 => 23
    )
  end

  it 'generate fills in empty values' do
    _, values = GraphUtil.make_power_graph_labels_and_values([])
    expect(values.size).to eql(96)
    expect(values.all? { |v| v == 0 }).to be(true)
  end

  it 'generate fills in partially empty array' do
    _, values = GraphUtil.make_power_graph_labels_and_values(
      [FakeValue.new(10), FakeValue.new(20), FakeValue.new(30)],
      hours: 4, hour_parts: 1
    )
    expect(values.size).to eql(4)
    expect(values).to contain_exactly(10, 20, 30, 0)
  end

  it 'generate does not pad full array' do
    _, values = GraphUtil.make_power_graph_labels_and_values(
      [FakeValue.new(10), FakeValue.new(20)],
      hours: 1, hour_parts: 2
    )
    expect(values.size).to eql(2)
    expect(values).to contain_exactly(10, 20)
  end

  it 'creates a power graph without an error' do
    labels, values = GraphUtil.make_power_graph_labels_and_values(
      [FakeValue.new(10), FakeValue.new(20)],
      hours: 1, hour_parts: 2
    )
    g = GraphUtil.power_graph(Date.new(2019, 1, 1), labels, values)
    expect(g.title).to eql('Power Over Time: 2019-01-01')
  end
end
