require_relative 'dijkstra/data'
# See https://github.com/RichOrElse/wrapper-based/blob/master/test/dijkstra_test.rb

module DestinationNode
  def shortest_path_from(neighbor, find_shortest)
    return [self] if equal? neighbor
    find_shortest.path(from: neighbor)
  end
end

Map = DCI::Module.new do |mod| using mod
  def distance_between(a, b)
    @distances[Edge.new(a, b)]
  end

  def distance_of(path)
    path.each_cons(2).inject(0) { |total, (to, from)| total + distance_between(from, to) }
  end

  def neighbors(near:)
    [south_neighbor_of(near), east_neighbor_of(near)].compact # excludes nil neighbors
  end
end

class FindShortest < DCI::Context(:from, to: DestinationNode, city: Map)
  def initialize(city:, from: city.root, to: city.destination) super end

  def distance
    city.distance_of path
  end

  def path(from: @from)
    shortest_neighbor_path(from) << from
  end

  private

  def shortest_neighbor_path(current)
    city.neighbors(near: current).
      map { |neighbor| to.shortest_path_from(neighbor, self) }.
      min_by { |neighbor_path| city.distance_of neighbor_path }
  end
end
