module WrapperBased
  class Context
    def initialize(**where)
      rebind where
    end

    def _casting_director_
      @_casting_director_ ||= CastingDirector.new(self.class)
    end

    def rebind(**where)
      where.each { |role, player| public_send :"#{role}=", player }
      self
    end

    def to_proc
      method(:call).to_proc
    end

    def [](*args, &block)
      call(*args, &block)
    end

    UnassignedRole = Class.new(StandardError)

    class << self
      alias_method :[], :new

      def call(**where)
        new(where).call
      end

      def cast_as(role, actor)
        send(role).typecast(actor)
      end

      protected

      def add_role(role, casting)
        add_reader_for(role)
        add_writer_for(role)
        add_role_to_class role, casting
      end

      def add_reader_for(role)
        define_method(role) do
          _casting_director_.fetch(role) { raise UnassignedRole, "Role '#{role}' is missing.", caller }
        end
      end

      def add_writer_for(role)
        role_player = :"@#{role}"
        define_method(:"#{role}=") do |actor|
          instance_variable_set(role_player, actor)
          _casting_director_.cast_as role, actor
        end
      end

      def add_role_to_class(role, casting)
        define_singleton_method(role) { casting }
      end
    end # class methods
  end # Context class
end # WrapperBased module
