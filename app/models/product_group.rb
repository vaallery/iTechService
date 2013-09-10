class ProductGroup < ActiveRecord::Base

  belongs_to :product_category
  has_many :products, inverse_of: :product_group
  has_ancestry orphan_strategy: :restrict
  attr_accessible :ancestry, :name, :parent_id, :product_category_id
  validates_presence_of :name

  after_initialize do |product_group|
    product_group.parent_id = nil if product_group.parent_id.blank?
    product_group.product_category_id ||= product_group.parent.product_category_id unless product_group.is_root?
  end

  scope :services, joins(:product_category).where(product_categories: {is_service: true})
  scope :goods, joins(:product_category).where(product_categories: {is_service: false})

  def is_feature_accounting?
    product_category.try(:feature_accounting)
  end

end
