class RepairService < ActiveRecord::Base
  belongs_to :repair_group
  attr_accessible :name, :price, :repair_group_id
  validates_presence_of :name, :price, :repair_group
end
