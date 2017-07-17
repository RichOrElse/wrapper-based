require 'set'

module WrapperBased
  class Context::Casting
    attr_reader :name

    def initialize(name, wrappers)
      @name = name.to_sym
      @casting = Set.new
      @wrappers = wrappers
    end

    def as(extention)
      @casting << extention
      self
    end

    def wrapper_for(*args)
      @wrappers[args]
    end

    def cast_type(type)
      wrapper_for type, *@casting
    end

    def typecast(actor)
      return actor if @casting.empty?
      cast_type(actor.class).new actor
    end
  end
end
