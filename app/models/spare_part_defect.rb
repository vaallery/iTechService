class SparePartDefect < ActiveRecord::Base
  belongs_to :item
  belongs_to :contractor

  attr_accessible :item_id, :contractor_id, :qty
  validates_presence_of :qty
  validates_numericality_of :qty, only_integer: true, greater_than: 0
end
