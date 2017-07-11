require 'delegate'

module WrapperBased
  module Context::TypeCasting
    refine Object do
      def as_role_played_by(actor)
        actor
      end
    end

    refine NilClass do
      def as_role_played_by(actor)
        yield
      end
    end

    refine Delegator do
      def as_role_played_by(actor)
        return replace_role_player_with(actor) if actor.instance_of?(role_type)
        yield
      end

      def replace_role_player_with(actor)
        __setobj__(actor)
        self
      end

      def role_type
        __getobj__.class
      end
    end # Delegator refinement
  end # TypeCasting module
end
