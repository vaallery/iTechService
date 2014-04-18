class SupplyReport < ActiveRecord::Base

  scope :date_desc, order('date desc')

  belongs_to :department
  has_many :supplies, dependent: :destroy
  accepts_nested_attributes_for :supplies, allow_destroy: true
  attr_accessible :date, :supplies_attributes, :department_id
  validates_presence_of :date
  validates_associated :supplies

  after_initialize do
    self.date ||= Date.current
    self.department_id ||= Department.current.id
  end

  def total_cost
    if supplies.any?
      supplies.map { |s|s.sum }.sum
    else
      0
    end
  end

end
