class Comment < ActiveRecord::Base
  scope :newest, ->{ order('comments.created_at desc') }
  scope :oldest, ->{ order('comments.created_at asc') }

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  attr_accessible :content, :commentable_id, :commentable_type

  validates :content, :user_id, :commentable_id, :commentable_type, presence: true

  def user_name
    user&.full_name
  end

  def user_color
    user&.color
  end
end
