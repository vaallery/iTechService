class SaleItem < ActiveRecord::Base

  belongs_to :sale, inverse_of: :sale_items
  belongs_to :item, inverse_of: :sale_items
  attr_accessible :sale_id, :item_id, :price, :quantity
  validates_presence_of :item, :price, :quantity

  def presentation
    item.present? ? item.name : '-'
  end

  def product
    item.try :product
  end

  def features_presentation
    item.present? ? item.features_presentation : ''
  end

  def store
    try(:sale).try(:store)
  end

  def price
    (store.present? and product.present?) ? product.actual_price(store.price_type) : 0
  end

  def sum
    price * (quantity || 0)
  end

end