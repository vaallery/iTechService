class Contractor < ActiveRecord::Base
  has_many :purchases, inverse_of: :contractor
  attr_accessible :name
end
