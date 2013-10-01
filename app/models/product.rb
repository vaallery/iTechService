class Product < ActiveRecord::Base

  belongs_to :product_group, inverse_of: :products
  has_many :items, inverse_of: :product
  has_many :prices, class_name: 'ProductPrice', inverse_of: :product
  has_many :store_items, through: :items
  accepts_nested_attributes_for :items, allow_destroy: true
  attr_accessible :code, :name, :product_group_id, :items_attributes
  validates_presence_of :name, :product_group

  scope :available, includes(:store_items).where('store_items.quantity > ?', 0)
  scope :in_store, lambda { |store| includes(:store_items).where(store_items: { store_id: store.is_a?(Store) ? store.id : store }) }

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
    if type.present?
      if type.is_a? Integer
        type = PriceType.find type
      elsif type.is_a?(String)
        type = PriceType.find_by_name type.to_s
      end
      type.try(:product_prices).try(:first)
    else
      nil
    end
  end

  def actual_prices
    PriceType.all.map do |type|
      prices.select(:value).where(price_type_id: type.id).first
    end
  end

  def available_quantity(store=nil)
    if store.present?
      store_items.in_store(store).count
    else
      store_items.count
    end
  end

end
