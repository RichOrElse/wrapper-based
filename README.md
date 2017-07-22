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

[Money Transfer](https://github.com/RichOrElse/wrapper-based/blob/master/examples/money_transfer.rb) | 
Djikstra | 
[Dijkstra test](https://github.com/RichOrElse/wrapper-based/blob/master/test/dijkstra_test.rb) | 
[Toy Shop](https://github.com/RichOrElse/wrapper-based/blob/master/examples/toy_shop.rb) | 
[Acapella](https://github.com/RichOrElse/wrapper-based/blob/master/examples/acapella.rb) | 
[Background Job](https://github.com/RichOrElse/wrapper-based/blob/master/examples/background_job.rb) | 
[see more examples](https://github.com/RichOrElse/wrapper-based/tree/master/examples)

```ruby
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
  def between(from, to)
    city.distance_between(from, to)
  end

  def of(path)
    path.each_cons(2).inject(0) { |total_distance, (to, from)| total_distance + between(from, to) }
  end

  alias_method :call, :of
end

class FindsShortest < DCI::Context(:road_distance, :from, to: DestinationNode, city: Map)
  def initialize city:, from: city.root, to: city.destination, road_distance: FindsDistance[city: city]
    super
  end

  def distance
    road_distance.of path
  end

  def path(from: @from)
    city.neighbors_of(from).map(&to_shortest_path).min_by(&road_distance).concat from
  end

  def call(neighbor = @from)
    to.shortest_path_from(neighbor, self)
  end

  private

  alias_method :to_shortest_path, :to_proc
end
```

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

### context#rebind(**params)
Assigns object to role.

```ruby
add_member = Evaluate.new(to: 'Justice League')
['Batman', 'Superman', 'Wonder Woman'].each do |founder|
  add_member.rebind(member: founder).(recruit: 'Supergirl')
end
```

## Context class methods

### klass#call(**params)

A shortcut for instantiating the context by passing the collaborators and then executing the context call method.

```ruby
Funds::TransferMoney.(from: @account1, to: @account2, amount: 50)
```

Which is equivalent to:

```ruby
Funds::TransferMoney.new(from: @account1, to: @account2, amount: 50).call
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
