# See: https://medium.com/kkempin/facade-design-pattern-in-ruby-on-rails-710aa88326f

class UsersFacade < DCI::Context(:user, :users, :active_users, vip: VipUsersPresenter)
  def initialize(user:, users: user.class, active_users: users.active, vip: active_users.vip) super end

  def new_user
    users.new
  end

  def last_active_users
    @last_active_users ||= active_users.order(:created_at).limit(10)
  end

  def vip_users
    @vip_users ||= vip.users
  end

  def messages
    @messages ||= user.messages
  end

  private :users, :active_users, :vip
end
