class
Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    alias_action :create, :update, to: :modify
    user ||= User.new # guest user (not logged in)
    if user.superadmin?
      can :manage, :all
      can :view_reports
    elsif user.admin?
      can :manage, :all
      can :view_reports
      cannot :manage, Salary unless user.able_to? :manage_salary
      cannot :manage_rights, User
    elsif user.programmer?
      can :manage, :all
    else
      if user.manager?
        can :manage, :all
        cannot [:modify, :destroy], User
        cannot :manage, Salary
      end
      if user.software?
        can :modify, [Device, Client]
        can [:issue, :activate, :scan], GiftCertificate
        can :modify, Sale
      end
      if user.media?
        can :modify, [Device, Client, Order]
      end
      if user.marketing?
        can :modify, Info
        can :manage, Price
        can :manage, DeviceType
        can :modify, Order
        can :modify, Client
        can :modify, Sale
        can :modify, SalesImport
        cannot :modify, Device
      end
      if user.supervisor?
        can :read, :all
        cannot :update, Device
        cannot :make_announce, Announcement
        cannot :create, Order
        cannot [:modify, :destroy], Comment
      end
      if user.technician?
        can :modify, Order
      end
      can :manage, WikiPage if user.able_to? :manage_wiki
      can :make_announce, Announcement
      can [:cancel_announce, :update], Announcement do |announcement|
        user.any_admin? or (announcement.user_id == user.id) or ((announcement.order_done? or announcement.order_status?) and (user.media?))
      end
      can :update, Announcement, user_id: user.id
      can :create, Order
      can :destroy, Order, user_id: user.id
      can :update, Device#, location_id: user.location_id
      can :profile, User, id: user.id
      can :update_wish, User, id: user.id
      can :duty_calendar, User, id: user.id
      can :update, DeviceTask, task: {role: user.role}#, device: {location_id: user.location_id}#, done: false
      can :create, Comment
      can :update, Comment, user_id: user.id
      can :create, Message
      can :read, Info, recipient_id: [nil, user.id]
      can :rating, User
      can :read, :all
      cannot [:create, :update, :destroy], StolenPhone
      cannot :read, Salary
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
