module WrapperBased
  class Context::Builder < Module
    def initialize(wrapper_for)
      class_variable_set :@@wrapper_for,
        Hash.new { |cache, type_casting| cache[type_casting] = wrapper_for[*type_casting] }
    end

    def wrapper_for(*type_casting)
      class_variable_get(:@@wrapper_for)[type_casting]
    end

    def Context(*roles, &block)
      dci = self
      Class.new(WrapperBased::Context) do
        roles.each { |role| add_role role, dci }
        class_eval(&block) unless block.nil?
      end
    end
  end # Context::Builder class
end # WrapperBased module
