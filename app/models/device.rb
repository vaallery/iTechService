class Device < ActiveRecord::Base
  belongs_to :client, inverse_of: :devices
  belongs_to :device_type
  has_many :device_tasks, dependent: :destroy
  has_many :tasks, through: :device_tasks
  attr_accessible :comment, :client_id, :device_type_id, :device_tasks_attributes
  accepts_nested_attributes_for :device_tasks
  
  validates :ticket_number, :client, :device_type, presence: true
  validates :ticket_number, uniqueness: true
  validates_associated :device_tasks
  
  before_validation :generate_ticket_number
  before_validation :check_device_type
  
  scope :undone, where(done_at: nil)
  
  scope :ordered, order("done_at desc")
  
  def type_name
    device_type.try :name
  end
  
  def client_name
    client.try :name
  end
  
  def client_phone
    client.try :phone_number
  end
  
  def done?
    device_tasks.all?{|t|t.done}
  end
  
  private
  
  def generate_ticket_number
    self.ticket_number ||= (Device.any?) ? (Device.last.ticket_number.to_i + 1).to_s : 1.to_s
  end
  
  def check_device_type
    device_type_id = DeviceType.find_or_create_by_name(type_name).id
  end
  
end