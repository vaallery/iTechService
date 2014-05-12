class Bank < ActiveRecord::Base
  has_many :payments, primary_key: :uid
  attr_accessible :name
  validates_presence_of :name
  after_create UidCallbacks
end