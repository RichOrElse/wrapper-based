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

    UnassignedRole = StandardError

    class << self
      def [](**role_cast, &block)
        context_class = Class.new(self, &block)

        context_class.class_eval do
          role_cast.each do |role, cast|
            role_player = :"@#{role}"

            define_method(:"#{role}=") do |actor|
              instance_variable_set(role_player, actor)
              @_casting[role] = context_class.send(role).typecast(actor)
            end

            define_method(role) do
              @_casting.fetch(role) { fail UnassignedRole, "Role '#{role}' is missing." }
            end
          end
        end

        context_class.singleton_class.class_eval do
          role_cast.each do |role, cast|
            variable = :"@@#{role}"
            define_method(role) { class_variable_get variable }
            context_class.class_variable_set variable, cast
          end

          alias_method :[], :new
        end

        context_class
      end # [] method
    end # singleton class
  end # Context class
end # WrapperBased module
