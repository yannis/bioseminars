class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    if user.new_record?
      can :read, :application
      can :read, Building
      can :read, Category
      can :read, Host
      can :read, Location
      can [:create, :destroy], :session
      can :read, Seminar

    else
      if user.admin?
        can :manage, :all
      else
        can :read, :application

        can [:read, :create, :update], Building
        can :destroy, Building do |building|
          building.locations.empty?
        end

        can :read, Category

        can [:create, :update, :destroy], Categorisation do |categorisation|
          if categorisation.seminar.present?
            categorisation.seminar.user_id == user.id
          else
            true
          end
        end

        can [:read, :create, :update], Host
        can [:destroy], Host do |host|
          host.seminars.empty?
        end

        can [:create, :update, :destroy], Hosting do |hosting|
          if hosting.seminar.present?
            hosting.seminar.user_id == user.id
          else
            true
          end
        end

        can [:destroy], Location do |location|
          location.seminars.empty?
        end
        can [:read, :create, :update], Location

        can [:read], Seminar
        can [:create, :update, :destroy], Seminar, user_id: user.id

        can [:create, :destroy], :session

        can [:read, :update], User, id: user.id
      end
    end
  end
end
