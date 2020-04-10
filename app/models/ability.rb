# class Ability
#   include CanCan::Ability
#
#   def initialize(user)
#     # Define abilities for the passed in user here. For example:
#     #
#     alias_action :create, :update, to: :modify
#     user ||= User.new # guest user (not logged in)
#     if user.superadmin?
#       can :manage, :all
#       can :read_tech_notice, ServiceJob
#       can :write_tech_notice, ServiceJob
#       can :view_purchase_price, Product
#     elsif user.admin?
#       can :manage, :all
#       can :finance, User if user.able_to? :manage_salary
#       cannot :manage, Salary unless user.able_to? :manage_salary
#       cannot :manage_rights, User
#       cannot :manage, [BonusType, Bonus, Setting]
#       cannot [:edit, :destroy], Karma
#       can :read_tech_notice, ServiceJob
#       can :write_tech_notice, ServiceJob
#       cannot :read, CashShift
#       cannot :close, CashShift
#       cannot [:update, :destroy], Location
#     elsif user.developer?
#       can :manage, :all
#       can :view_purchase_price, Product
#     elsif user.api?
#       can :sync, Product
#       can :read, [ServiceJob, Order]
#     else
#       if user.manager?
#         can :manage, :all
#         cannot :manage, Salary unless user.able_to? :manage_salary
#         cannot :manage_rights, User
#         cannot :manage, [BonusType, Bonus]
#         cannot [:edit, :destroy], Karma
#         cannot :read_tech_notice, ServiceJob
#         cannot :write_tech_notice, ServiceJob
#         cannot :destroy, [Client, ServiceJob]
#       end
#       if user.software?
#         can :modify, ServiceJob
#         can :create, Client
#         can :create_sale, ServiceJob
#         can [:issue, :activate, :scan, :find], GiftCertificate
#         can [:modify, :read, :reprint_check, :print_warranty], Sale
#         can %i[select], ProductGroup
#         can [:find, :choose, :select], Product
#         can %i[modify autocomplete remains_in_store], Item
#         can [:post, :edit, :attach_gift_certificate, :return_check], Sale, status: 0
#         can :create, CashOperation
#         can [:create, :set_done], QuickOrder
#         can :update, QuickOrder, {user_id: user.id}
#         can :create, Service::FreeJob
#         can :create, Payment
#       end
#       if user.media?
#         can :modify, [ServiceJob, Order, QuickOrder, MediaOrder]
#         can :create, Client
#         can :set_done, QuickOrder
#         can [:find, :choose, :select], Product
#       end
#       if user.marketing?
#         can :modify, Info
#         can :manage, Price
#         can :manage, DeviceType
#         can :modify, Order
#         can :modify, Client
#         can :modify, Sale
#         can :modify, SalesImport
#         can [:find, :choose, :select, :modify], Product
#         cannot :modify, ServiceJob
#       end
#       if user.supervisor?
#         can :read, :all
#         cannot :update, ServiceJob
#         cannot :make_announce, Announcement
#         cannot :create, Order
#         cannot [:modify, :destroy], Comment
#       end
#       if user.technician?
#         can :modify, Order
#         can :read_tech_notice, ServiceJob
#         can :write_tech_notice, ServiceJob
#         can :repair, ServiceJob
#         can [:choose, :select], Product
#         can [:choose, :select], RepairService
#         can :make_defect_sp, MovementAct
#         can [:create, :post], MovementAct, {status: 0, is_from_spare_parts?: true, is_to_defect?: true}
#       end
#       if user.has_role? %w[technician media]
#         can [:read, :create], SupplyRequest
#         can [:update, :destroy], SupplyRequest, user_id: user.id, status: 'new'
#       end
#       if user.driver?
#         can :read, SupplyRequest
#         can :make_done, SupplyRequest, status: 'new'
#         can :make_new, SupplyRequest, status: 'done'
#         can [:create, :read], SupplyReport
#       end
#       can [:update], Client if user.able_to? :edit_clients
#       can :manage, WikiPage if user.able_to? :manage_wiki
#       can :make_announce, Announcement
#       can :close_all, Announcement
#       can :close, Announcement do |announcement|
#         announcement.visible_for? user
#       end
#       can [:cancel_announce, :update], Announcement do |announcement|
#         user.any_admin? or (announcement.user_id == user.id) or ((announcement.order_done? or announcement.order_status?) and (user.media?))
#       end
#       can :create, Order
#       can :destroy, Order, user_id: user.id
#       can :update, ServiceJob#, location_id: user.location_id
#       can :print_receipt, ServiceJob do |service_job|
#         (service_job.user_id == user.id) or user.any_admin? or user.able_to?(:print_receipt)
#       end
#       can :profile, User, id: user.id
#       can :update_wish, User, id: user.id
#       can :duty_calendar, User, id: user.id
#       can :update, DeviceTask, task: {role: user.role}
#       can :create, Comment
#       can :update, Comment, user_id: user.id
#       can :create, Message
#       can :read, Info, recipient_id: [nil, user.id]
#       can :rating, User
#       can :manage, TimesheetDay if user.able_to? :manage_timesheet
#       can :manage, [ScheduleDay, DutyDay] if user.able_to? :manage_schedule
#       can %i[duty_calendar staff_duty_schedule schedule create_duty_day destroy_duty_day], User if user.able_to? :manage_schedule
#       can :print_check, Sale if Setting.print_sale_check?
#       can :create, DeviceNote
#       can :manage, FavoriteLink, owner_id: user.id
#       can :read, :all
#       unless user.driver?
#         cannot :read, SupplyReport
#       end
#       cannot [:create, :update, :destroy], StolenPhone
#       cannot :read, Salary
#       cannot(:manage, Report) unless user.can_view_reports?
#     end
#     can :set_keeper, ServiceJob
#     can :read, Fault, causer_id: user.id
#     can(:manage, Report) if user.can_view_reports?
#     cannot [:edit, :post], [Purchase, RevaluationAct, Sale, MovementAct, DeductionAct], status: [1, 2]
#     cannot :unpost, [Purchase, RevaluationAct, Sale, MovementAct, DeductionAct], status: [0, 2]
#     cannot :destroy, [Purchase, RevaluationAct, Sale, MovementAct, DeductionAct], status: 1
#     cannot :destroy, Store
#     cannot(:manage, Report) unless user.can_view_reports?
#     #
#     # The first argument to `can` is the action you are giving the user permission to do.
#     # If you pass :manage it will apply to every action. Other common actions here are
#     # :read, :create, :update and :destroy.
#     #
#     # The second argument is the resource the user can perform the action on. If you pass
#     # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
#     #
#     # The third argument is an optional hash of conditions to further filter the objects.
#     # For example, here the user can only update published articles.
#     #
#     #   can :update, Article, :published => true
#     #
#     # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
#   end
# end
