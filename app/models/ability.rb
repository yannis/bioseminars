class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :create, :update, :to => :create_or_update
    if user.persisted?
      if user.admin?
        can :read, :all
        can :manage, Seminar
        can :manage, User
        can :reorder, Category
        can [:create_or_update], [Building, Category, Host, Location, Speaker]
        can :destroy, Building do |building|
          building.locations.blank?
        end
        can :destroy, Category do |category|
          category.seminars.blank?
        end
        can :destroy, Host do |host|
          host.seminars.blank?
        end
        can :destroy, Location do |location|
          location.seminars.blank?
        end
      elsif user.basic?
        can :read, [Building, Category, Host, Location, Seminar, Speaker]
        can [:create_or_update], [Building, Speaker, Host, Location]
        can :destroy, Building do |building|
          building.locations.blank?
        end
        can :destroy, Host do |host|
          host.seminars.blank?
        end
        can :destroy, Location do |location|
          location.seminars.blank?
        end
        can :create, Seminar
        can :update, Seminar, :user_id => user.id
        can :destroy, Seminar, :user_id => user.id
      end
    else
      can :read, [Building, Category, Host, Location, Seminar, Speaker]
    end
  end
end