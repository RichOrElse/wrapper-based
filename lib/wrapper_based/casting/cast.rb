module WrapperBased
  class Casting::Cast
    extend Forwardable
    using Context::TypeCasting

    def initialize
      @played = {}
    end

    def as(role, actor, &recast)
      @played[role] = @played[role].as_role_played_by(actor, &recast)
    end

    def_delegators :@played, :fetch, :[], :[]=
  end
end
