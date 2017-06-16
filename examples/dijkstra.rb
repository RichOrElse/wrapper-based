require_relative 'dijkstra/data'
# See https://github.com/RichOrElse/wrapper-based/blob/master/test/dijkstra_test.rb

# Behaviors

module Map
  def distance_between(a, b)
    @distances[Edge.new(a, b)]
  end

  def distance_of(path)
    Distance[within: self].of(path)
  end
end

module CurrentIntersection
  def neighbors(nearest:)
    east_neighbor = nearest.east_neighbor_of(self)
    south_neighbor = nearest.south_neighbor_of(self)
    [south_neighbor, east_neighbor].compact
  end
end

module DestinationNode
  def shortest_path(from:, within:)
    return [self] if equal? from
    Shortest[to: self, from: from, city: within].path
  end
end

# Contexts

DCI = WrapperBased::DCI.new unless defined? DCI

class Distance < DCI::Context(:within)
  within.as Map

  def between(from, to)
    within.distance_between(from, to)
  end

  def of(path)
    path.reverse.each_cons(2).inject(0) { |total_distance, pair| total_distance + between(*pair) }
  end
end

class Shortest < DCI::Context(:from, :to, :city)
  from.as CurrentIntersection
  to.as DestinationNode
  city.as Map

  def distance
    city.distance_of path
  end

  def path
    _shortest_path + [@from]
  end

  private

  def _shortest_path
    from.
      neighbors(nearest: @city).
      map { |neighbor| to.shortest_path from: neighbor, within: @city }.
      min_by { |path| city.distance_of path }
  end
end
