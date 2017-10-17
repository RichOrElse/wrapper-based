require 'forwardable'
require "wrapper_based/version"
require "wrapper_based/context"
require "wrapper_based/context/producer"
require "wrapper_based/context/type_casting"
require "wrapper_based/casting"
require "wrapper_based/casting/type"
require "wrapper_based/casting/director"
require "wrapper_based/casting/cast"
require "wrapper_based/dci"

module WrapperBased
  def with!(**role_players)
    role_players.each { |role, player| send :"with_#{role}!", player }
    self
  end

  private

  def __cast__
    @__cast__ ||= Casting::Cast.new
  end
end
