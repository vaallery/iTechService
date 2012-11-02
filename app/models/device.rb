class Device < ActiveRecord::Base
  belongs_to :client
  belongs_to :device_type
  has_many :tasks, through: :devices_tasks
  attr_accessible :ticket_number, :comment
  
  validates :ticket_number, :client, :device_type, presence: true
  validates :ticket_number, uniqueness: true
  
  def type_name
    device_type.try :name
  end
  
  def client_name
    client.try :name
  end
end
