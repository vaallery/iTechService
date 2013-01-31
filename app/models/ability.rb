class
Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    alias_action :create, :update, to: :modify
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.programmer?
      can :manage, :all
    else
      if user.software?
        can :modify, [Device, Client]
      end
      def user.media?
        can :modify, [Device, Client]
      end
      if user.marketing?
        can :manage, Price
        can :manage, DeviceType
        can :manage, Order
      end
      if user.helpable?
        can :call_help, Announcement
        can :cancel_help, Announcement, user_id: user.id
      end
      can :check_phone_number, Client
      can :questionnaire, Client
      can :create, Order
      can :read, Info
      can :update, Device
      can :profile, User, id: user.id
      can :update_wish, User, id: user.id
      can :update, DeviceTask, task: {role: user.role}#, done: false
      can :modify, Comment
      can :read, :all
      cannot [:create, :update, :destroy], StolenPhone
    end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
