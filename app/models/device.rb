class Device < ActiveRecord::Base
  belongs_to :client, inverse_of: :devices
  belongs_to :device_type
  has_many :device_tasks, dependent: :destroy
  has_many :tasks, through: :device_tasks
  attr_accessible :comment, :client_attributes, :device_type_attributes, :device_tasks_attributes
  accepts_nested_attributes_for :client, :device_type, :device_tasks
  
  validates :ticket_number, :client, :device_type, presence: true
  validates :ticket_number, uniqueness: true
  
  before_validation :generate_ticket_number
  before_validation :check_device_type
  
  def type_name
    device_type.try :name
  end
  
  def client_name
    client.try :name
  end
  
  def client_phone
    client.try :phone_number
  end
  
  private
  
  def generate_ticket_number
    self.ticket_number ||= (Device.any?) ? (Device.last.ticket_number.to_i + 1).to_s : 1.to_s
  end
  
  def check_device_type
    if (existing_device_type = DeviceType.find_by_name(self.type_name)).present?
      self.device_type_id = existing_device_type.id
    end
  end
  
end
