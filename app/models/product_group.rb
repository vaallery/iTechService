class ProductGroup < ActiveRecord::Base

  scope :services, joins(:product_category).where(product_categories: {kind: 'service'})
  scope :goods, joins(:product_category).where(product_categories: {kind: %w[equipment accessory]})

  belongs_to :product_category
  has_many :products, inverse_of: :product_group
  has_many :product_relations, as: :parent, dependent: :destroy
  has_many :related_products, through: :product_relations, source: :relatable, source_type: 'Product'
  has_many :related_product_groups, through: :product_relations, source: :relatable, source_type: 'ProductGroup'
  has_ancestry orphan_strategy: :restrict, cache_depth: true

  delegate :feature_accounting, :feature_types, :warranty_term, :is_service, to: :product_category, allow_nil: true

  attr_accessible :name, :ancestry, :parent_id, :product_category_id, :related_product_ids, :related_product_group_ids
  validates_presence_of :name, :product_category

  after_initialize do |product_group|
    product_group.parent_id = nil if product_group.parent_id.blank?
    unless product_group.is_root?
      product_group.product_category_id ||= product_group.parent.product_category_id
    end

  end

end
