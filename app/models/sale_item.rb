class SaleItem < ActiveRecord::Base

  belongs_to :sale, inverse_of: :sale_items
  belongs_to :item, inverse_of: :sale_items
  attr_accessible :sale_id, :item_id, :price, :quantity
  validates_presence_of :item, :price, :quantity

  delegate :product, :presentation, :features_presentation, :name, to: :item, allow_nil: true
  delegate :store, to: :sale

  def actual_price
    (store.present? and item.present?) ? item.actual_price(store.price_types.first) : 0
  end

  def sum
    (price || 0) * (quantity || 0)
  end

end