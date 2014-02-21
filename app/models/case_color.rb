class CaseColor < ActiveRecord::Base

  default_scope order('name asc')
  scope :ordered_by_name, order('name asc')
  attr_accessible :color, :name
  validates_presence_of :name, :color

end
