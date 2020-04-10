class StorePolicy < BasePolicy
  def modify?
    same_department? && any_manager?
  end

  def destroy?; false; end

  def product_details?; read?; end
end
