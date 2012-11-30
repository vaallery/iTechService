class DeviceType < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true
  validates :name, uniqueness: true
  has_ancestry
  
  default_scope order('id')
end
