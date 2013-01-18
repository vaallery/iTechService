class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  attr_accessible :content, :user_id, :commentable_id, :commentable_type
  validates :content, :user_id, :commentable_id, :commentable_type, presence: true
  before_validation do |comment|
    comment.user_id = User.current.id
  end

  def user_name
    user.full_name
  end
end
