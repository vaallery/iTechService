class Product < ActiveRecord::Base

  #belongs_to :group
  belongs_to :category
  has_many :features
  has_many :batches, inverse_of: :product
  has_many :stock_items, as: :item
  has_ancestry
  #has_many :feature_types, through: :category
  accepts_nested_attributes_for :features
  attr_accessible :code, :name, :parent_id, :category_id, :features_attributes
  validates_presence_of :name, :category#, :group

  #after_save :check_feature_accounting

  def self.search(params)
    products = Product.scoped
    unless (product_q = params[:product_q]).blank?
# TODO products search
    end
    products
  end

  private

  #def check_feature_accounting
  #  self.feature_accounting = self.features.any?
  #end

end
