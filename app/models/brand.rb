class Brand < ApplicationRecord
  mount_uploader :logo, IconUploader
  attr_accessible :name, :logo
  validates_presence_of :name
end
