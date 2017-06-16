require 'test_helper'
require_relative '../examples/dijkstra'

class ManhattanGeometryTest < MiniTest::Test
  def test_manhattan_geometries_1
    geometries = ManhattanGeometry1.new
    shortest = Shortest[from: geometries.root, to: geometries.destination, city: geometries]
    names = []
    shortest.path.each { |node| names << node.name }
    assert_equal %w(i h g d a), names
    assert_equal 6, shortest.distance
  end

  def test_manhattan_geometries_2
    geometries = ManhattanGeometry2.new
    shortest = Shortest[from: geometries.root, to: geometries.destination, city: geometries]
    actual = []
    current_node = nil
    
    shortest.path.each do |node|
      if current_node
        actual <<  Distance[within: geometries].between(node, current_node)
      end
      actual << node.name
      current_node = node
    end
    assert_equal ["k", 1, "j", 1, "c", 3, "b", 2, "a"], actual

    assert_equal 7, shortest.distance
  end
end
