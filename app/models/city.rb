class City < ApplicationRecord
  has_many :selectable_departments, -> { Department.selectable }, class_name: 'Department'

  attr_accessible :name, :color
  validates_presence_of :name
end
