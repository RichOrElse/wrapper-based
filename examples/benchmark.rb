# Derived from https://tonyarcieri.com/dci-in-ruby-is-completely-broken
require 'rubygems'
require 'benchmark/ips'
require 'wrapper_based'

class ExampleClass
  def foo; 42; end
end

module ExampleMixin
  def foo; 43; end
end

wrapper = WrapperBased::FORWARDING[ExampleClass, ExampleMixin]

Benchmark.ips do |bm|
  bm.report("without dci") { ExampleClass.new.foo }
  bm.report("with wrapper") do
    wrapper.new(ExampleClass.new).foo
  end
  bm.report("with extend") do
    obj = ExampleClass.new
    obj.extend(ExampleMixin)
    obj.foo
  end
  bm.compare!
end
