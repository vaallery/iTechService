class ProductGroup < ActiveRecord::Base

  belongs_to :product_category
  has_many :products, inverse_of: :product_group
  has_ancestry orphan_strategy: :restrict
  attr_accessible :ancestry, :name, :parent_id, :product_category_id
  validates_presence_of :name, :product_category

  scope :services, joins(:product_category).where(product_categories: {is_service: true})
  scope :goods, joins(:product_category).where(product_categories: {is_service: false})

end
