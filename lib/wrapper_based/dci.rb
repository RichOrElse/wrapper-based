module WrapperBased
  class DCI < Module
    def initialize(wrapper_for = FORWARDING)
      @@wrapper_for = Hash.new do |cache, type_casting|
        cache[type_casting] = wrapper_for[*type_casting]
      end unless defined? @@wrapper_for

      def wrapper_for(*type_casting)
        @@wrapper_for[type_casting]
      end unless defined? self.wrapper_for

      def Context(*roles, &block)
        dci = self
        Class.new(WrapperBased::Context) do
          roles.each { |role| add_role role, WrapperBased::Cast.new(role, dci) }
          class_eval(&block) unless block.nil?
        end
      end unless defined? self.Context
    end # initialize method
  end # DCI class
end # WrapperBased module
