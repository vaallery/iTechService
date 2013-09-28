class ProductPrice < ActiveRecord::Base

  belongs_to :product
  belongs_to :price_type
  attr_accessible :value, :date, :product_id, :price_type_id
  validates_presence_of :product, :price_type, :date, :value
  validates_uniqueness_of :date, scope: [:product_id, :price_type_id]

  after_initialize do
    date ||= Date.current
  end

  default_scope order('date desc')

end
