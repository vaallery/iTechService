class ProductCategory < ActiveRecord::Base

  has_and_belongs_to_many :feature_types
  attr_accessible :name, :is_service, :request_price, :feature_accounting, :feature_type_ids
  validates_presence_of :name

  before_validation do |product_category|
    product_category.feature_accounting = product_category.feature_type_ids.any?
  end

end
