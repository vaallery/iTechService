class Client < ActiveRecord::Base
  has_many :devices
  attr_accessible :name, :phone_number
  
  validates :name, :phone_number, presence: true
end
