require 'test_helper'
require_relative '../examples/dijkstra'

class ManhattanGeometryTest < MiniTest::Test
  def test_manhattan_geometries_1
    finds_shortest = FindsShortest.new city: ManhattanGeometry1.new
    assert_equal %w(i h g d a), finds_shortest.path.map(&:name)
    assert_equal 6, finds_shortest.distance
  end

  def test_manhattan_geometries_2
    city = ManhattanGeometry2.new
    finds_shortest = FindsShortest.new city: city
    finds_distance = FindsDistance[city]
    actual, current_node = [], nil
    finds_shortest.path.each do |node|
      actual <<  finds_distance.between(node, current_node) if current_node
      actual << node.name
      current_node = node
    end
    assert_equal ["k", 1, "j", 1, "c", 3, "b", 2, "a"], actual
    assert_equal 7, finds_shortest.distance
  end
end
