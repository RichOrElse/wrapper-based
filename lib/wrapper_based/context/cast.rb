require 'set'

module WrapperBased
  class Context::Cast
    attr_reader :name, :dci

    def initialize(name, dci)
      @name = name.to_sym
      @casting = Set.new
      @dci = dci
    end

    def as(extention)
      @casting << extention
      self
    end

    def cast_type(type)
      @dci.wrapper_for type, *@casting
    end

    def typecast(actor)
      return actor if @casting.empty?
      cast_type(actor.class).new actor
    end
  end
end
