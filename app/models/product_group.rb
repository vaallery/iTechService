class ProductGroup < ActiveRecord::Base

  belongs_to :product_category
  has_many :products, inverse_of: :product_group
  has_ancestry orphan_strategy: :restrict
  attr_accessible :name, :is_service, :request_price, :ancestry, :parent_id, :product_category_id
  validates_presence_of :name
  delegate :feature_accounting, to: :product_category

  after_initialize do |product_group|
    product_group.parent_id = nil if product_group.parent_id.blank?
    unless product_group.is_root?
      product_group.product_category_id ||= product_group.parent.product_category_id
      product_group.is_service = product_group.parent.is_service
      product_group.request_price = product_group.parent.request_price
    end

  end

  scope :services, where(is_service: true)
  scope :goods, where(is_service: false)

end
