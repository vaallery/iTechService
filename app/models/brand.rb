class Brand < ApplicationRecord
  mount_uploader :logo, LogoUploader
  attr_accessible :name, :logo
  validates_presence_of :name
end
