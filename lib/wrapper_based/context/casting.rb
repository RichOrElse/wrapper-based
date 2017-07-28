require 'set'

module WrapperBased
  class Context::Casting
    attr_reader :name

    def initialize(name, wrappers)
      @name = name.to_sym
      @talents = Set.new
      @wrappers = wrappers
    end

    def as(talent)
      @talents << talent
      self
    end

    def wrapper_for(*args)
      @wrappers[args]
    end

    def cast_type(type)
      wrapper_for type, *@talents
    end

    def typecast(actor)
      return actor if @talents.empty?
      cast_type(actor.class).new actor
    end
  end
end
