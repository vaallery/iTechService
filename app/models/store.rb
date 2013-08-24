class Store < ActiveRecord::Base
  has_and_belongs_to_many :price_types
  attr_accessible :name, :price_type_ids
  validates_presence_of :name
end
