class SaleItem < ActiveRecord::Base

  belongs_to :sale, inverse_of: :sale_items
  belongs_to :item, inverse_of: :sale_items
  attr_accessible :sale_id, :item_id, :price, :quantity
  validates_presence_of :item, :price, :quantity

  delegate :product, :presentation, :features_presentation, :name, :code, :available_quantity, :actual_retail_price, to: :item, allow_nil: true
  delegate :store, :client, to: :sale, allow_nil: true

  def sum
    (price || 0) * (quantity || 0)
  end

  def discount
    (product.present? and client.present?) ? Discount::available_for(client, product) : 0
  end

end