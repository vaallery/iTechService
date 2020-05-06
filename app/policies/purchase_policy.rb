class PurchasePolicy < DocumentPolicy
  def manage?
    superadmin? || able_to?(:manage_stocks)
  end
end
