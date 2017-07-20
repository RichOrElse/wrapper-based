module WrapperBased
  class Roles < Module
    Unassigned = Class.new(StandardError)

    def initialize(wrappers, *roles, **where, &block)
      @casting_agent = (where.keys | roles.map(&:to_sym)).inject {|cast, role| cast[role] = Casting.new(role, wrappers) }
      @casting_agent.keys.each { |role| add_role role }
      where.each_pair {|role, trait| @casting[role].as trait }
      define_casting_director(@casting_agent)
      include InstanceMethods
    end

    def cast_as role, actor

    end

    def defing_casting_director(casting_agent)
      define_method(:_casting_director_) { @_casting_director ||= CastingDirector.new(casting_agent) }
    end

    def cast_as(role, actor)
      @casting[role].typecast actor
    end

    def add_role(role)
      add_reader_for(role)
      add_writer_for(role)
    end

    def add_reader_for(role)
      define_method(role) do
        _casting_director_.fetch(role) { raise Roles::Unassigned, "Role '#{role}' is missing.", caller }
      end
    end

    def add_writer_for(role)
      role_player = :"@#{role}"
      define_method(:"#{role}=") do |actor|
        instance_variable_set(role_player, actor)
        _casting_director_.cast_as role, actor
      end
    end

    def add_role_to_class(role, casting)
      define_singleton_method(role) { casting }
    end

    def define_casting_director
      roles = self
    end

    def included(base)
      base.extend ClassMethods
    end

    module InstanceMethods
      def rebind(**where, &block)
        where.each { |role, player| public_send :"#{role}=", player }
        instance_eval &block if block_given?
        self
      end
    end
  end
end
