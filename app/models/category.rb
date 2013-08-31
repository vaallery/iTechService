class Category < ActiveRecord::Base
  has_and_belongs_to_many :feature_types
  attr_accessible :name, :feature_type_ids, :is_service, :request_price, :feature_accounting
  validates_presence_of :name
end
