class FeatureValue < ActiveRecord::Base
  belongs_to :feature_type
  attr_accessible :name
end
