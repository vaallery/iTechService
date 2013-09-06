class Product < ActiveRecord::Base

  belongs_to :product_group, inverse_of: :products
  has_many :items, inverse_of: :product
  attr_accessible :code, :name, :product_group_id
  validates_presence_of :name, :product_group

  after_initialize do |product|
    if product.new_record? and product.parent.present?
      product.category_id = product.parent.category_id
    end
  end

  def self.search(params)
    products = Product.scoped
    unless (product_q = params[:product_q]).blank?
# TODO products search
    end
    products
  end

  def is_feature_accounting?
    product_group.product_category.feature_accounting
  end

  def feature_types
    product_group.product_category.feature_types
  end

end
