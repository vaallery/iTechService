class DeviceNote < ActiveRecord::Base
  scope :newest_first, ->{order('device_notes.created_at desc')}
  belongs_to :service_job, required: true
  belongs_to :user, required: true
  attr_accessible :content, :service_job_id, :user_id
  validates_presence_of :content
  before_validation do |device_note|
    device_note.user_id = User.current.try(:id)
  end

  def user_name
    user.try(:full_name)
  end

end
