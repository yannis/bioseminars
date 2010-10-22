class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.basic?
      can :create, Seminar
      can :update, Seminar, :user_id => user.id
      can :destroy, Seminar, :user_id => user.id
    else
      can :read, :all
    end
  end
end
