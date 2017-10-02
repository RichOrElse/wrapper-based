require 'set'

module WrapperBased
  class Casting::Type
    attr_reader :name

    def initialize(name, talent_pool)
      @name = name.to_sym
      @talents = Set.new
      @lookup = talent_pool
    end

    def has(talent)
      @talents << talent
      self
    end

    def [](*where)
      @lookup[where]
    end

    def cast_type(type)
      self[type, *@talents]
    end

    def typecast(actor)
      return actor if @talents.empty?
      cast_type(actor.class).new actor
    end
  end
end
