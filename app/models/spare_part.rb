class SparePart < ActiveRecord::Base
  belongs_to :repair_service
  belongs_to :product
  has_many :store_items, through: :product
  delegate :name, :quantity_threshold, :comment, :quantity_in_store, :purchase_price, to: :product, allow_nil: true
  attr_accessible :quantity, :warranty_term, :repair_service_id, :product_id
  validates_presence_of :quantity, :product

  after_initialize do
    self.warranty_term ||= product.try(:warranty_term)
  end

  def remnant
    store_items.in_store(Store.spare_part_ids).sum(:quantity)
  end

  def remnant_s
    if remnant <= 0
      'none'
    elsif remnant > (quantity_threshold || 0)
      'many'
    else
      'low'
    end
  end

end
