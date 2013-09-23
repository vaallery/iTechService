class Product < ActiveRecord::Base

  belongs_to :product_group, inverse_of: :products
  has_many :items, inverse_of: :product
  has_many :prices, class_name: 'ProductPrice', inverse_of: :product
  has_many :store_items, through: :items
  accepts_nested_attributes_for :items, allow_destroy: true
  attr_accessible :code, :name, :product_group_id, :items_attributes
  validates_presence_of :name, :product_group

  def self.search(params)
    products = Product.scoped
    unless (product_q = params[:product_q]).blank?
      products = products.where 'LOWER(name) LIKE :q OR code LIKE :q', q: "%#{product_q.mb_chars.downcase.to_s}%"
    end
    products
  end

  def is_feature_accounting?
    product_group.is_feature_accounting?
  end

  def feature_types
    product_group.product_category.feature_types
  end

  def actual_price(type)
    if type.is_a? Integer
      type = PriceType.find type
    elsif type.is_a?(String)
      type = PriceType.find_by_name type.to_s
    end
    type.try(:product_prices).try(:first)
  end

end
