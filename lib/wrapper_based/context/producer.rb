module WrapperBased
  class Context::Producer
    def initialize(wrapper_for)
      @talent_table = Hash.new do |cache, type_casting|
        cache[type_casting] = wrapper_for[*type_casting]
      end
    end

    def casting_for(*supporting_roles, **leading_roles)
      WrapperBased::Casting::Director.new(@talent_table).tap do |director|
        supporting_roles.each(&director)
        leading_roles.each { |role, talent| director.adds role, talent }
      end.casting
    end

    def context_for(*roles, &script)
      klass = Class.new(Context).include casting_for(*roles)
      klass.class_exec(&script) if block_given?
      klass
    end
  end # Context class
end # WrapperBased module
