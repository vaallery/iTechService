class Batch < ActiveRecord::Base

  belongs_to :purchase, inverse_of: :batches
  belongs_to :item, inverse_of: :batches
  attr_accessible :price, :quantity, :item_id
  validates_presence_of :item, :price, :quantity
  delegate :code, :name, :product, :features_presentation, to: :item, allow_nil: true

  def sum
    (price || 0) * (quantity || 0)
  end

end
