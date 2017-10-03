class SubstitutePhone::Policy < BasePolicy
  alias_method :substitute_phone, :record

  def index?
    user.present?
  end

  def view_stock?
    index?
  end
end
