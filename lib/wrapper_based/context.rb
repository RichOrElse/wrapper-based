module WrapperBased
  class Context
    def initialize(**where)
      @casting_director = CastingDirector.new(self.class)
      where.each { |role, player| send :"#{role}=", player }
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

      def add_role(role, dci)
        add_reader_for(role)
        add_writer_for(role)
        add_to_class_cast_for role, Casting.new(role, dci)
      end

      def add_reader_for(role)
        define_method(role) do
          @casting_director.fetch(role) { raise UnassignedRole, "Role '#{role}' is missing.", caller }
        end
      end

      def add_writer_for(role)
        role_player = :"@#{role}"

        define_method(:"#{role}=") do |actor|
          instance_variable_set(role_player, actor)
          @casting_director.cast_as role, actor
        end
      end

      def add_to_class_cast_for(role, casting)
        role_casting = :"@@#{role}"

        singleton_class.class_eval do
          define_method(role) { class_variable_get role_casting }
        end

        class_variable_set role_casting, casting
      end
    end # class methods
  end # Context class
end # WrapperBased module
