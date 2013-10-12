class ProductPrice < ActiveRecord::Base

  belongs_to :product
  belongs_to :price_type
  attr_accessible :value, :date, :product_id, :price_type_id
  validates_presence_of :product, :price_type, :date, :value
  validates_uniqueness_of :date, scope: [:product_id, :price_type_id]

  scope :with_type, lambda { |type| where(price_type_id: type.is_a?(PriceType) ? type.id : type) }

  after_initialize do
    date ||= Date.current
  end

  default_scope order('date desc')

end
