class Item < ActiveRecord::Base

  belongs_to :product, inverse_of: :items
  has_many :batches, inverse_of: :item
  has_and_belongs_to_many :features, uniq: true
  attr_accessible :product_id
  validates_presence_of :product

  def name
    product.name
  end

end
