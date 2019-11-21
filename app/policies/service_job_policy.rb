class ServiceJobPolicy < BasePolicy
  def view_repair_parts?
    (record.at_done? || record.in_archive?) && (superadmin? || able_to?(:view_repair_parts))
  end

  def inventory?
    superadmin? || able_to?(:inventory)
  end
end
