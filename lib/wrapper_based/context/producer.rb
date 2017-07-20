module WrapperBased
  class Context
    class Producer
      def initialize(wrapper_for)
        @wrapper_cache = Hash.new do |cache, type_casting|
          cache[type_casting] = wrapper_for[*type_casting]
        end
      end

      def produce(*supporting, **leading, &script)
        wrappers = @wrapper_cache
        roles = supporting.map(&:to_sym) | leading.keys
        Class.new(Context) do
          roles.each { |role| add_role role, Casting.new(role, wrappers) }
          leading.each_pair { |role, trait| send(role).as trait }
          class_eval(&script) unless script.nil?
        end
      end # produce method
    end # Producer class
  end # Context class
end # WrapperBased module
