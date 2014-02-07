class CashOperation < ActiveRecord::Base

  belongs_to :cash_shift, inverse_of: :cash_operations
  belongs_to :user

  attr_accessible :is_out, :value
  validates_presence_of :value, :user, :cash_shift
  validates_numericality_of :value, greater_than: 0
  before_validation :set_user
  before_validation :set_cash_shift

  after_initialize do
    self.user_id ||= User.try(:current).try(:id)
  end

  private

  def set_user
    self.user_id ||= User.try(:current).try(:id)
  end

  def set_cash_shift
    self.cash_shift_id ||= CashShift.current.id
  end

end
