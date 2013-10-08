class Revaluation < ActiveRecord::Base

  belongs_to :revaluation_act, inverse_of: :revaluations
  belongs_to :product, inverse_of: :revaluations
  attr_accessible :price
  validates_presence_of :revaluation_act, :product, :price
  delegate :code, :name, to: :product, allow_nil: true

end
