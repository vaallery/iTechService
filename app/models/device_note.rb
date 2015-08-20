class DeviceNote < ActiveRecord::Base
  scope :newest_first, order('device_notes.created_at desc')
  belongs_to :device
  belongs_to :user
  attr_accessible :content, :device_id, :user_id
  validates_presence_of :content, :device_id, :user_id
  before_validation do |device_note|
    device_note.user_id = User.current.try(:id)
  end

  def user_name
    user.try(:full_name)
  end

end
