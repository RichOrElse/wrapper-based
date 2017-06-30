require_relative 'dijkstra/data'
# See https://github.com/RichOrElse/wrapper-based/blob/master/test/dijkstra_test.rb

# Behaviors

module Map
  def distance_between(a, b)
    @distances[Edge.new(a, b)]
  end

  def distance_of(path)
    GetDistance[within: self].of(path)
  end
end

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

# Contexts

class GetDistance < DCI::Context(:within)
  within.as Map

  def between(from, to)
    within.distance_between(from, to)
  end

  def of(path)
    path.reverse.each_cons(2).inject(0) { |total_distance, pair| total_distance + between(*pair) }
  end
end

class FindShortest < DCI::Context(:from, :to, :city)
  from.as CurrentIntersection
  to.as DestinationNode
  city.as Map

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
