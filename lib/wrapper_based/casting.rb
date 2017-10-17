module WrapperBased
  UnassignedRole = Class.new(StandardError)

  class Casting < Module
    def initialize
      include WrapperBased
    end

    def casts(role)
      role_player = :"@#{role}"

      define_method(:"with_#{role}!") do |value|
        instance_variable_set(role_player, value)
        __cast__[role] = yield(value)
        self
      end

      private_reader role
    end

    def casts_as(role, &recast)
      role_player = :"@#{role}"

      define_method(:"with_#{role}!") do |actor|
        instance_variable_set(role_player, actor)
        __cast__.as(role, actor, &recast)
        self
      end

      private_reader role
    end

    private

    def private_reader(role)
      define_method(role) do
        __cast__.fetch(role) { raise UnassignedRole, "Role '#{role}' is missing.", caller }
      end

      private role
    end
  end
end
