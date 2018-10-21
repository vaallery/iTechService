class OrderNote < ActiveRecord::Base
  scope :oldest_first, -> { order(created_at: :asc) }
  belongs_to :order
  belongs_to :author, class_name: 'User'
  attr_accessible :order_id, :author_id, :content
  validates_presence_of :content

  def author_color
    author&.color
  end

  def author_name
    author&.full_name
  end
end
