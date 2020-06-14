class SalePolicy < DocumentPolicy
  def read?; true; end

  def create?
    any_manager?(:software, :universal, :marketing)
  end

  def update?
    editable? && any_manager?(:software, :universal, :marketing)
  end

  def post?
    postable? && any_manager?(:software, :universal)
  end

  def print_check?
    Setting.print_sale_check?
  end

  def reprint_check?
    any_manager?(:software, :universal)
  end

  def print_warranty?
    any_manager?(:software, :universal)
  end

  def attach_gift_certificate?
    any_manager?(:software, :universal) && record.is_new?
  end

  def return_check?
    any_manager?(:software, :universal) && record.is_new?
  end

  def edit_price?
    superadmin? || able_to?(:edit_price_in_sale)
  end
end
