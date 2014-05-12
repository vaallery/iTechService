class CashDrawer < ActiveRecord::Base

  belongs_to :department, primary_key: :uid
  has_many :cash_shifts, inverse_of: :cash_drawer, primary_key: :uid
  delegate :name, to: :department, prefix: true, allow_nil: true
  attr_accessible :name, :department_id
  validates_presence_of :name, :department
  after_create UidCallbacks

  def current_shift
    cash_shifts.opened.first_or_create(is_closed: false)
  end

end
