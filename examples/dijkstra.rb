require_relative 'dijkstra/data'
# See https://github.com/RichOrElse/wrapper-based/blob/master/test/dijkstra_test.rb

module DestinationNode
  def shortest_path_from(node, find_shortest)
    return [self] if equal? node
    find_shortest.path from: node
  end
end

Map = DCI::Module.new do |mod| using mod
  def distance_between(a, b)
    @distances[Edge.new(a, b)]
  end

  def distance_of(path)
    path.each_cons(2).inject(0) { |total, (to, from)| total + distance_between(from, to) }
  end

  def neighbors_of(node)
    [south_neighbor_of(node), east_neighbor_of(node)].compact # excludes nil neighbors
  end

  def find_shortest_neighbor_path(node, &to_shortest_path)
    neighbors_of(node).
      map(&to_shortest_path).
      min_by { |neighbor_path| distance_of neighbor_path }
  end
end

class FindShortest < DCI::Context(:from, to: DestinationNode, city: Map)
  def initialize(city:, from: city.root, to: city.destination) super end

  def distance
    city.distance_of path
  end

  def path(from: @from)
    city.find_shortest_neighbor_path(from, &self) << from
  end

  def call(neighbor = @from)
    to.shortest_path_from(neighbor, self)
  end
end
