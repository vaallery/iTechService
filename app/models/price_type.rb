class PriceType < ActiveRecord::Base

  has_many :product_prices, inverse_of: :price_type
  has_and_belongs_to_many :stores
  attr_accessible :name
  validates_presence_of :name

end
