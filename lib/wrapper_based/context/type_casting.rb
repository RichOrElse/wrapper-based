require 'delegate'

module WrapperBased
  module Context::TypeCasting
    refine NilClass do
      def as_role_played_by(actor)
        yield
      end
    end

    refine Delegator do
      def as_role_played_by(actor)
        return replace_role_player_with(actor) if role_type_same_as?(actor)
        yield
      end

      def replace_role_player_with(actor)
        __setobj__(actor)
        self
      end

      def role_type_same_as?(actor)
        actor.instance_of?(__getobj__.class)
      end
    end
  end
end
