module WrapperBased
  UnassignedRole = Class.new(StandardError)

  class Casting < Module
    def initialize
      include WrapperBased
    end

    def casts(role)
      role_writer = :"#{role}="

      define_method(:"with_#{role}!") do |value|
        send role_writer, yield(value)
        self
      end

      private_reader role
      private_writer role
    end

    def casts_as(role, &recast)
      role_player = :"@#{role}"

      define_method(:"with_#{role}!") do |actor|
        _components[role] = cast_as(role, actor, &recast)
        instance_variable_set(role_player, actor)
        self
      end

      private_reader role
      private_writer role
    end

    private

    def private_reader(role)
      define_method(role) do
        _components.fetch(role) { raise UnassignedRole, "Role '#{role}' is missing.", caller }
      end

      private role
    end

    def private_writer(role)
      writer = :"#{role}="
      role_player = :"@#{role}"

      define_method(writer) do |value|
        _components[role] = value
        instance_variable_set(role_player, value)
      end

      private writer
    end
  end
end
