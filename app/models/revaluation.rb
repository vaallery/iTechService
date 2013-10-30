class Revaluation < ActiveRecord::Base

  belongs_to :revaluation_act, inverse_of: :revaluations
  belongs_to :product, inverse_of: :revaluations
  attr_accessible :price, :product_id, :revaluation_act_id
  validates_presence_of :revaluation_act, :product, :price
  delegate :code, :name, :prices, :actual_purchase_price, :actual_retail_price, to: :product, allow_nil: true

end
