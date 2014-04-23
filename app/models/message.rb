class Message < ActiveRecord::Base

  scope :newest, order("messages.created_at desc")
  scope :today, lambda { where('created_at > ?', Time.current.beginning_of_day) }

  belongs_to :user
  belongs_to :recipient, polymorphic: true

  attr_accessible :content, :recipient_id, :recipient_type
  validates :content, presence: true
  validates :content, length: {maximum: 255}
  before_validation do |message|
    message.user_id = User.current.id
  end
end
