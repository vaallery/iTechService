class RepairService < ActiveRecord::Base
  belongs_to :repair_group
  has_many :spair_parts
  accepts_nested_attributes_for :spair_parts
  attr_accessible :name, :price, :repair_group_id, :spair_parts_attributes
  validates_presence_of :name, :price, :repair_group
  validates_associated :spair_parts
end
