class SupplyReport < ActiveRecord::Base
  attr_accessible :date
  validates_presence_of :date
end
