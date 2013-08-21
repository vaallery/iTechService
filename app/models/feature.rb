class Feature < ActiveRecord::Base
  belongs_to :feature_type
  belongs_to :product
  belongs_to :value
  # attr_accessible :title, :body
end
