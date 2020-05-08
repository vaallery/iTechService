class PurchasePolicy < DocumentPolicy
  def manage?
    superadmin? || able_to?(:manage_stocks)
  end

  def print_barcodes?; manage? end

  def revaluate_products?; manage? end

  def move_items?; manage? end
end
