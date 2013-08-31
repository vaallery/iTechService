class Feature < ActiveRecord::Base

  belongs_to :feature_type
  belongs_to :product
  has_one :stock_item, as: :item
  attr_accessible :value, :product, :product_id, :feature_type, :feature_type_id
  validates_presence_of :value, :product, :feature_type

  def name
    feature_type.name
  end

end
