class Item < ActiveRecord::Base

  belongs_to :product, inverse_of: :items
  has_many :batches, inverse_of: :item
  has_many :store_items, inverse_of: :item
  has_and_belongs_to_many :features, uniq: true
  accepts_nested_attributes_for :features, allow_destroy: true
  attr_accessible :product_id, :features_attributes
  validates_presence_of :product

  paginates_per 5

  def name
    product.name
  end

  def features_presentation
    features.any? ? features.map { |feature| "#{feature.name}: #{feature.value}" }.join('; ') : '-'
  end

  def is_feature_accounting?
    product.is_feature_accounting?
  end

  def self.search(params)
    items = Item.scoped
    unless (item_q = params[:item_q]).blank?
      items = includes(:features).where('features.value LIKE :q', q: "%#{item_q}%")
    end
    items
  end

  def prices
    product.try :prices
  end

end
