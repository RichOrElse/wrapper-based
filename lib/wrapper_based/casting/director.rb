module WrapperBased
  TALENTLESS = -> actor { actor }

  class Casting::Director < Struct.new(:casting, :talent_pool)
    def initialize(talent_pool) super(Casting.new, talent_pool) end

    def adds(role, talent = TALENTLESS)
      case talent
      when ::Proc, ::Method, ::Symbol
        casting.casts role, &talent
      when ::Class
        casting.casts role, &talent.method(:new)
      when ::Module
        casting.casts_as role, &type_for(role).has(talent).method(:typecast)
      else
        throw :wrong_talent_type, [role, talent, "expected Module, Class, Proc, Method or Symbol"]
      end
    end

    def to_proc
      method(:adds).to_proc
    end

    def type_for(role)
      Casting::Type.new(role, talent_pool)
    end
  end
end
