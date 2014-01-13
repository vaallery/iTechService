class SupplyReport < ActiveRecord::Base

  has_many :supplies, dependent: :destroy
  accepts_nested_attributes_for :supplies, allow_destroy: true
  attr_accessible :date, :supplies_attributes
  validates_presence_of :date
  validates_associated :supplies

end
