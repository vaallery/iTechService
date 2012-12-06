class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.admin?
      #can :manage, :all
      can :manage, Device
      cannot :remove_device_tasks, Device
    else
      if user.software?
        can :receive, Device
        can :manage, [Device, Client]
      end
      can :update, Device
      cannot :update, DeviceTask
      cannot :change_location, Device, new_record?: true
      can :manage_device_task, DeviceTask, task: {role: user.role}, done: false
      cannot :remove_device_tasks, Device, new_record?: false
      cannot :change_client, Device
      cannot :change_device_type, Device
      cannot :change_serial_number, Device
      cannot :change_device_comment, Device
      can :read, :all
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
