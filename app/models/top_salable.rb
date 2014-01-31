class TopSalable < ActiveRecord::Base

  scope :ordered, order('position asc')
  belongs_to :salable, polymorphic: true
  delegate :name, to: :salable, allow_nil: true
  attr_accessible :color, :position, :salable_id, :salable_type
  validates_numericality_of :position, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 20
  validates_uniqueness_of :position

end
