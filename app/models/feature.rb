class Feature < ActiveRecord::Base

  belongs_to :feature_type
  has_and_belongs_to_many :items
  attr_accessible :value, :feature_type_id
  validates_presence_of :value, :feature_type
  validates_uniqueness_of :value, scope: [:feature_type_id]

  def name
    feature_type.name
  end

end
