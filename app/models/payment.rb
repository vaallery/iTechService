class Payment < ActiveRecord::Base
  belongs_to :payment_type
  belongs_to :bank
  attr_accessible :value
end
