class RepairService < ActiveRecord::Base
  belongs_to :repair_group
  has_many :spare_parts
  accepts_nested_attributes_for :spare_parts
  attr_accessible :name, :price, :repair_group_id, :spare_parts_attributes
  validates_presence_of :name, :price, :repair_group
  validates_associated :spare_parts
end
