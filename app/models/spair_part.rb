class SpairPart < ActiveRecord::Base
  belongs_to :repair_service
  belongs_to :item
  attr_accessible :quantity, :warranty_term
end
