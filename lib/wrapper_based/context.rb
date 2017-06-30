module WrapperBased
  class Context
    def initialize(**where)
      @_casting = {}
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

      protected

      def add_role(role, caster)
        add_reader_for(role)
        add_writer_for(role)
        add_to_class(role, caster)
      end

      def add_reader_for(role)
        define_method(role) do
          @_casting.fetch(role) { raise UnassignedRole, "Role '#{role}' is missing." }
        end
      end

      def add_writer_for(role)
        role_player = :"@#{role}"

        define_method(:"#{role}=") do |actor|
          instance_variable_set(role_player, actor)
          @_casting[role] = self.class.send(role).typecast(actor)
        end
      end

      def add_to_class(role, caster)
        role_caster = :"@@#{role}"

        singleton_class.class_eval do
          define_method(role) { class_variable_get role_caster }
        end

        class_variable_set role_caster, caster
      end
    end # ClassMethods module
  end # Context class
end # WrapperBased module
