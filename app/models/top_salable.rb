class TopSalable < ActiveRecord::Base

  scope :ordered, order('position asc')
  belongs_to :product
  delegate :name, to: :product, prefix: true, allow_nil: true
  has_ancestry orphan_strategy: :restrict
  attr_accessible :name, :color, :position, :ancestry, :parent_id, :product_id, :type
  validates_numericality_of :position, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 20
  validates_uniqueness_of :position, scope: :ancestry
  before_save do
    #if self.type == 'Group'
    #  self.product_id = nil
    #else
    #  self.name = nil
    #end
  end
  after_initialize {self.type ||= 'Group'}

  def title
    product_name || name
  end

  def type=(value)
    if value == 'Group'
      self.product_id = nil
    else
      self.name = nil
    end
  end

  def type
    self.product.present? ? 'Product' : 'Group'
  end

end
