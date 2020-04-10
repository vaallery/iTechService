module Service
  class SMSNotificationPolicy < ApplicationPolicy
    def manage?; true; end
  end
end
