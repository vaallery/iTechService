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
  
  def presentation
    serial_number.blank? ? type_name : [type_name, serial_number].join(' | ')
  end
  
  def done?
    device_tasks.pending.empty?
  end
  
  def pending?
    !done?
  end
  
  def self.search params
    Device.scoped
    
  end
  
  def done_tasks
    device_tasks.where done: true
  end
  
  def pending_tasks
    device_tasks.where done: false
  end
  
  def is_important?
    tasks.important.any?
  end
  
  def progress
    "#{done_tasks.count} / #{device_tasks.count}"
  end
  
  def progress_pct
    (done_tasks.count * 100.0 / device_tasks.count).to_i
  end
  
  private
  
  def generate_ticket_number
    self.ticket_number ||= (Device.any?) ? (Device.last.ticket_number.to_i + 1).to_s : 1.to_s
  end
  
  def check_device_type
    device_type_id = DeviceType.find_or_create_by_name(type_name).id
  end
  
end