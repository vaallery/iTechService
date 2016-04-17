class FavoriteLink < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  validates :url, presence: true
end
