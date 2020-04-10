class SalePolicy < DocumentPolicy
  def read?; true; end

  def create?
    any_manager?(:software, :marketing)
  end

  def update?
    editable? && any_manager?(:software, :marketing)
  end

  def post?
    postable? && any_manager?(:software)
  end

  def print_check?
    Setting.print_sale_check?
  end

  def reprint_check?
    any_manager?(:software)
  end

  def print_warranty?
    any_manager?(:software)
  end

  def attach_gift_certificate?
    any_manager?(:software) && record.is_new?
  end

  def return_check?
    any_manager?(:software) && record.is_new?
  end
end
