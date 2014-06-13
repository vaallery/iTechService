class Batch < ActiveRecord::Base

  belongs_to :purchase, inverse_of: :batches
  belongs_to :item, inverse_of: :batches
  attr_accessible :price, :quantity, :item_id
  validates_presence_of :item, :price, :quantity
  validates_numericality_of :quantity, only_integer: true, greater_than: 0, unless: :feature_accounting
  validates_numericality_of :quantity, only_integer: true, equal_to: 1, if: :feature_accounting
  delegate :code, :name, :product, :features, :feature_accounting, :store_item, :prices, :purchase_price, :retail_price, :barcode_num, :is_equipment, :is_spare_part, to: :item, allow_nil: true

  scope :newest, includes(:purchase).order('purchases.date desc')

  after_initialize do
    self.price ||= purchase_price
    self.quantity ||= 1
  end

  def sum
    (price || 0) * (quantity || 0)
  end

end
