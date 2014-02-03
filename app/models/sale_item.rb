class SaleItem < ActiveRecord::Base

  belongs_to :sale, inverse_of: :sale_items
  belongs_to :item, inverse_of: :sale_items

  delegate :product, :product_category, :presentation, :features, :name, :code, :quantity_in_store, :retail_price, :purchase_price, :feature_accounting, :store_item, :store_items, :is_service, :request_price, to: :item, allow_nil: true
  delegate :store, :client, to: :sale, allow_nil: true

  attr_accessible :sale_id, :item_id, :price, :quantity, :discount
  validates_presence_of :item, :price, :quantity
  validates_numericality_of :quantity, only_integer: true, greater_than: 0, unless: :feature_accounting
  validates_numericality_of :quantity, only_integer: true, equal_to: 1, if: :feature_accounting
  validates_numericality_of :discount, greater_than_or_equal_to: 0, less_than_or_equal_to: :max_discount
  validates_numericality_of :price, greater_than_or_equal_to: :min_price

  after_initialize do
    self.quantity ||= 1
    self.price ||= retail_price - available_discount if retail_price.present?
    self.discount ||= available_discount
  end

  def sum
    (price || 0) * (quantity || 0)
  end

  def available_discount
    (client.present? and item.present?) ? Discount::available_for(client, item) : 0
  end

  def discount=(new_discount)
    if retail_price.nil? or new_discount.to_f > available_discount
      self.errors.add :discount, I18n.t('sales.errors.unavailable_discount')
    else
      self.price = retail_price - new_discount.to_f
      super
    end
  end

  def max_discount
    (product.present? and client.present?) ? Discount::max_available_for(client, item) : 0
  end

  def min_price
    retail_price - max_discount
  end

end