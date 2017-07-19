require_relative 'dijkstra/data'
# See https://github.com/RichOrElse/wrapper-based/blob/master/test/dijkstra_test.rb

module CurrentIntersection
  def neighbors(manhattan:)
    east_neighbor = manhattan.east_neighbor_of(self)
    south_neighbor = manhattan.south_neighbor_of(self)
    [south_neighbor, east_neighbor].compact # excludes nil neighbors
  end
end

module DestinationNode
  def shortest_path(from:, within:)
    return [self] if equal? from
    FindShortest[to: self, from: from, city: within].path
  end
end

Map = DCI::Module.new do |mod| using mod
  def distance_between(a, b)
    @distances[Edge.new(a, b)]
  end

  def distance_of(path)
    path.each_cons(2).inject(0) { |total, (to, from)| total + distance_between(from, to) }
  end
end

class FindShortest < DCI::Context(from: CurrentIntersection, to: DestinationNode, city: Map)
  def distance
    city.distance_of path
  end

  def path
    shortest_path_from_city_neighbors << @from
  end

  private

  def shortest_path_from_city_neighbors
    from.
      neighbors(manhattan: @city).
      map { |neighbor| to.shortest_path from: neighbor, within: @city }.
      min_by { |path| city.distance_of path }
  end
end
