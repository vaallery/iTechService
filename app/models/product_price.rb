class ProductPrice < ActiveRecord::Base

  belongs_to :product
  belongs_to :price_type
  attr_accessible :value, :date, :product_id, :price_type_id
  validates_presence_of :product, :price_type, :date, :value

  default_scope order('date desc')

end
