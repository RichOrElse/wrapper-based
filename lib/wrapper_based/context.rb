module WrapperBased
  class Context
    def initialize(**where)
      @_casting_director_ = CastingDirector.new(self.class)
      where.each { |role, player| public_send :"#{role}=", player }
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
          @_casting_director_.fetch(role) { raise UnassignedRole, "Role '#{role}' is missing.", caller }
        end
      end

      def add_writer_for(role)
        role_player = :"@#{role}"
        define_method(:"#{role}=") do |actor|
          instance_variable_set(role_player, actor)
          @_casting_director_.cast_as role, actor
        end
      end

      def add_role_to_class(role, casting)
        role_casting = :"@@#{role}"
        class_variable_set role_casting, casting
        define_singleton_method(role) { class_variable_get role_casting }
      end
    end # class methods
  end # Context class
end # WrapperBased module
