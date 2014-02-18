class CashDrawer < ActiveRecord::Base

  belongs_to :department
  has_many :cash_shifts
  delegate :name, to: :department, prefix: true, allow_nil: true
  attr_accessible :name, :department_id
  validates_presence_of :name, :department

  def current_shift
    cash_shifts.find_or_create_by_is_closed false
  end

end
