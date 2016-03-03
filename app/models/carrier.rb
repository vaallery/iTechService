class Carrier < ActiveRecord::Base
  default_scope {order('name asc')}
  attr_accessible :name
  validates_presence_of :name
end
