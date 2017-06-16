module WrapperBased
  class Context
    def initialize(**where)
      where.each { |role, player| instance_variable_set :"@#{role}", player }
    end

    def to_proc
      method(:call).to_proc
    end

    def [](*args, &block)
      call(*args, &block)
    end

    class << self
      def [](**role_cast, &block)
        context_class = Class.new(self, &block)

        context_class.class_eval do
          role_cast.each do |role, cast|
            class_variable_set :"@@#{role}", cast
            define_method(role) do
              self.class.class_variable_get(:"@@#{role}").
                typecast instance_variable_get(:"@#{role}")
            end
          end
        end

        context_class.singleton_class.class_eval do
          role_cast.each do |role, _|
            define_method(role) do
              class_variable_get :"@@#{role}"
            end
          end

          alias_method :[], :new
        end

        context_class
      end # [] method
    end # singleton class
  end # Context class
end # WrapperBased module
