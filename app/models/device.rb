class Device < ActiveRecord::Base
  belongs_to :client
  belongs_to :device_type
  has_many :tasks, through: :devices_tasks
  attr_accessible :ticket_number, :comment
end
