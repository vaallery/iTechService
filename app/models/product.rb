class Product < ActiveRecord::Base

  belongs_to :group
  belongs_to :category
  has_many :features
  accepts_nested_attributes_for :features
  attr_accessible :code, :name, :is_service, :request_price, :group, :category, :features_attributes
  validates_presence_of :name, :category, :group

  def self.search(params)
    products = Product.scoped
    unless (product_q = params[:product_q]).blank?
# TODO products search
    end
    products
  end

end
