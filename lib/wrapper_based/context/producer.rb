module WrapperBased
  class Context
    class Producer
      def initialize(wrapper_for)
        @wrapper_cache = Hash.new do |cache, type_casting|
          cache[type_casting] = wrapper_for[*type_casting]
        end
      end

      def produce(*roles, **mixins, &block)
        wrappers = @wrapper_cache
        Class.new(Context) do
          (mixins.keys | roles.map(&:to_sym)).each { |role| add_role role, Casting.new(role, wrappers) }
          mixins.each_pair { |role, trait| send(role).as trait }
          class_eval(&block) unless block.nil?
        end
      end
    end # Producer class
  end # Context class
end # WrapperBased module
