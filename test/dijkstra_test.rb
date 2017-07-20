require 'test_helper'
require_relative '../examples/dijkstra'

class ManhattanGeometryTest < MiniTest::Test
  def test_manhattan_geometries_1
    find_shortest = FindShortest.new city: ManhattanGeometry1.new
    assert_equal %w(i h g d a), find_shortest.path.map(&:name)
    assert_equal 6, find_shortest.distance
  end

  def test_manhattan_geometries_2
    context              = FindShortest.new city: ManhattanGeometry2.new
    city, path, distance = context.city, context.path, context.distance
    actual, current_node = [], nil
    path.each do |node|
      actual <<  city.distance_between(node, current_node) if current_node
      actual << node.name
      current_node = node
    end
    assert_equal ["k", 1, "j", 1, "c", 3, "b", 2, "a"], actual
    assert_equal 7, distance
  end
end
