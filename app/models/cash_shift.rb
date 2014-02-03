class CashShift < ActiveRecord::Base

  scope :closed, where(is_closed: true)

  belongs_to :user
  has_many :sales, inverse_of: :cash_shift
  attr_accessible :is_closed

  def self.current
    find_or_create_by_is_closed false
  end

end
