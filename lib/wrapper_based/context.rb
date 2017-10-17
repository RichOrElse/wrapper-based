module WrapperBased
  class Context
    def initialize(*role_players)
      with!(*role_players)
    end

    def to_proc
      method(:call).to_proc
    end

    def call(*)
      raise NotImplementedError, "Context must implement a call method."
    end

    class << self
      alias_method :[], :new

      def call(*role_players, &blk)
        new(*role_players).call(&blk)
      end
    end # class methods
  end # Context class
end # WrapperBased module
