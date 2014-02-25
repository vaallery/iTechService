class RepairGroup < ActiveRecord::Base
  has_ancestry orphan_strategy: :restrict, cache_depth: true
  has_many :repair_services
  attr_accessible :ancestry, :name, :parent_id
  validates_presence_of :name
end
