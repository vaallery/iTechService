class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipient, polymorphic: true
  attr_accessible :content, :recipient_id, :recipient_type
  validates :content, presence: true
  validates :content, length: {maximum: 255}
  scope :newest, order("messages.created_at desc")
  scope :today, lambda { where('created_at > ?', Time.current.beginning_of_day) }
  before_validation do |message|
    message.user_id = User.current.id
  end
end
