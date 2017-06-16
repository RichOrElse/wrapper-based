# WrapperBased

[![Gem Version](https://badge.fury.io/rb/wrapper_based.svg)](https://badge.fury.io/rb/wrapper_based)

Wrapper Based DCI implementation in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wrapper_based'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wrapper_based

## Usage

```ruby
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
```
[View more examples](https://github.com/RichOrElse/wrapper-based/tree/master/examples)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RichOrElse/wrapper-based.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
