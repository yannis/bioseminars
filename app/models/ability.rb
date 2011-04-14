class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    alias_action :create, :update, :to => :create_or_update
    
    if user.persisted?
      if user.admin?
        can :manage, Building
        can :destroy, Building do |building|
          building.locations.blank?
        end
        
        can :manage, Category
        # can [:read, :create_or_update, :reorder], Category
        # can :destroy, Category do |category|
        #   category.seminars.blank?
        # end
        
        can :manage, Host
        can :destroy, Host do |host|
          host.seminars.blank?
        end
        
        can :manage, Location
        can :destroy, Location do |location|
          location.seminars.blank?
        end
        
        can :manage, Seminar
        
        can :manage, Speaker
        
        can :manage, User
        
      elsif user.basic?
        can :read, Building
        can [:read, :create_or_update], Building
        can :destroy, Building do |building|
          building.locations.blank?
        end
        
        can :read, Category
        
        can :read, Host
        can [:create_or_update], Host
        can :destroy, Host do |host|
          host.seminars.blank?
        end
        
        can :read, Location
        can [:create_or_update], Location
        can :destroy, Location do |location|
          location.seminars.blank?
        end
        
        can [:read, :calendar, :create, :load_publications, :about], Seminar
        can [:update, :destroy], Seminar, :user_id => user.id
        
        can :read, Speaker
        can [:create_or_update], Speaker
      end
    else
      can :read, Building
      can :read, Category
      can :read, Host
      can :read, Location
      can [:read, :calendar, :load_publications, :about], Seminar
      can :read, Speaker
    end
  end
end