require 'forwardable'

module WrapperBased
  class Context::CastingDirector
    extend Forwardable
    using Context::TypeCasting

    def initialize(context_class)
      @casts = {}
      @re = context_class
    end

    def cast_as(role, actor)
      @casts[role] = @casts[role].as_role_played_by(actor) { recast_as(role, actor) }
    end

    def_delegator :@re, :cast_as, :recast_as
    def_delegators :@casts, :fetch, :[]
  end
end
