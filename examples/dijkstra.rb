require_relative 'dijkstra/data'
# See https://github.com/RichOrElse/wrapper-based/blob/master/test/dijkstra_test.rb

module DestinationNode
  def shortest_path_from(node, finds_shortest)
    return [self] if equal? node
    finds_shortest.path from: node
  end
end

module Map
  def distance_between(a, b)
    @distances[Edge.new(a, b)]
  end

  def neighbors_of(node)
    [south_neighbor_of(node), east_neighbor_of(node)].compact
  end
end

class FindsDistance < DCI::Context(city: Map)
  def initialize(city) super(city: city) end

  def between(from, to)
    city.distance_between(from, to)
  end

  def of(path)
    path.each_cons(2).inject(0) { |total_distance, (to, from)| total_distance + between(from, to) }
  end

  alias_method :call, :of
end

class FindsShortest < DCI::Context(:from, to: DestinationNode, city: Map, road_distance: FindsDistance)
  def initialize(city:, from: city.root, to: city.destination, road_distance: city) super end

  def distance
    road_distance.of path
  end

  def path(from: @from)
    city.neighbors_of(from).map(&to_shortest_path).min_by(&road_distance) << from
  end

  def call(neighbor = @from)
    to.shortest_path_from(neighbor, self)
  end

  private

  alias_method :to_shortest_path, :to_proc
end
