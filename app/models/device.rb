class Device < ActiveRecord::Base
  belongs_to :client
  belongs_to :device_type
  has_many :tasks, through: :devices_tasks
  attr_accessible :comment, :client_attributes, :device_type_attributes
  accepts_nested_attributes_for :client, :device_type
  
  validates :ticket_number, :client, :device_type, presence: true
  validates :ticket_number, uniqueness: true
  
  before_validation :assign_ticket_number
  
  def type_name
    device_type.try :name
  end
  
  def client_name
    client.try :name
  end
  
  private
  
  def assign_ticket_number
    # self.ticket_number ||= (Device.maximum('ticket_number') || 0) + 1
    self.ticket_number ||= (Device.any?) ? (Device.last.ticket_number.to_i + 1).to_s : 1.to_s
  end
end
