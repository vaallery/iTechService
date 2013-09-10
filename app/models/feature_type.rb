class FeatureType < ActiveRecord::Base
  has_and_belongs_to_many :product_categories
  attr_accessible :name, :code
  validates_presence_of :name, :code
end
