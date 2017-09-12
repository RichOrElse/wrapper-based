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
        key, value, expected = catch(:wrong_trait_type) do
          return Class.new(Context) do
            roles.each { |role| add_role role, Casting.new(role, wrappers) }
            leading.each_pair { |role, trait| cast_to(role, trait) }
            class_eval(&script) unless script.nil?
          end
        end
        raise TypeError, "'#{key}: #{value}' has wrong key value type #{value.class} (#{expected})", caller
      end # produce method
    end # Producer class
  end # Context class
end # WrapperBased module
