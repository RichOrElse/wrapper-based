require "wrapper_based/version"
require "wrapper_based/context"
require "wrapper_based/casting"
require "wrapper_based/casting/type"
require "wrapper_based/casting/director"
require "wrapper_based/casting/pool"
require "wrapper_based/dci"
require "wrapper_based/type_casting"
require "wrapper_based/role_unknown"

module WrapperBased
  def with!(**role_players)
    role_players.each { |role, player| send :"with_#{role}!", player }
    self
  rescue NoMethodError => error
    raise RoleUnknown.or(error)
  end

  private

  using TypeCasting

  def cast_as(role, actor, &recast)
    _components[role].as_role_played_by(actor, &recast)
  end

  def _components
    @_components ||= {}
  end
end
