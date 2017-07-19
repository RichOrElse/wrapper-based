# WrapperBased

[![Gem Version](https://badge.fury.io/rb/wrapper_based.svg)](https://badge.fury.io/rb/wrapper_based)
[![Build Status](https://travis-ci.org/RichOrElse/wrapper-based.svg?branch=master)](https://travis-ci.org/RichOrElse/wrapper-based)

Wrapper Based DCI framework for OOP done right.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wrapper_based'
```

And then execute:

    $ bundle

## Usage

[Dijkstra data](https://github.com/RichOrElse/wrapper-based/blob/master/examples/dijkstra/data.rb) | 
[Dijkstra test](https://github.com/RichOrElse/wrapper-based/blob/master/test/dijkstra_test.rb) | 
Djikstra example:

```ruby
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
```

[View more examples](https://github.com/RichOrElse/wrapper-based/tree/master/examples)

## Context methods

### context#to_proc

Returns call method as a Proc.

```ruby
['Card Wars', 'Ice Ninja Manual', 'Bacon'].map &GiftToy[gifter: 'Jake', giftee: 'Finn']
```

### context[params,...]

Square brackets are alias for call method.

```ruby
TransferMoney[from: source_account, to: destination_account][amount: 100]
```

## DCI::Module

Extention module for supporting procedural code. Define a block with the 'new' method and pass the 'mod' parameter to 'using' keyword.

```ruby
AwesomeSinging = TypeWrapper::Module.new do |mod| using mod
  def sing
    "#{name} sings #{song}"
  end

  def song
    "Everything is AWESOME!!!"
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RichOrElse/wrapper-based.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
