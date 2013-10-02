class FeatureType < ActiveRecord::Base
  has_and_belongs_to_many :product_categories
  attr_accessible :name, :code, :product_category_ids
  validates_presence_of :name, :code
  validates_uniqueness_of :code
end
