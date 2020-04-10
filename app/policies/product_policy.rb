class ProductPolicy < CommonPolicy
  def modify?
    any_manager?(:marketing)
  end

  def destroy?
    any_manager?
  end

  def show_prices?
    any_manager?
  end

  def show_remains?
    any_manager?
  end

  def remains_in_store?
    any_manager?
  end

  def view_purchase_price?
    superadmin?
  end

  def view_remnants?
    superadmin?
  end

  def sync?
    has_role?(:api)
  end

  def find?
    has_role?(:software, :media, :marketing)
  end

  def choose?
    has_role?(:software, :media, :marketing, :technician)
  end

  def related?
    read?
  end

  def select?
    has_role?(:software, :media, :marketing, :technician)
  end
end