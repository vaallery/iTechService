class Bank < ActiveRecord::Base

  has_many :payments

  attr_accessible :name
  validates_presence_of :name
end
