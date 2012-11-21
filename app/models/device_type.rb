class DeviceType < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true
  validates :name, uniqueness: true
  
  default_scope order('id')
end
