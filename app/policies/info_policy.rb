class InfoPolicy < BasePolicy
  def manage?; any_manager?(:marketing); end

  def show?
    same_department? && (manage? || [nil, user.id].include?(record.recipient_id))
  end
end
