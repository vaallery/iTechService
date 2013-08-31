class Batch < ActiveRecord::Base
  belongs_to :purchase, inverse_of: :batches
  belongs_to :product, inverse_of: :batches
  attr_accessible :price, :quantity
end
