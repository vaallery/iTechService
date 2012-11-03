class DeviceTask < ActiveRecord::Base
  belongs_to :device
  belongs_to :task
  attr_accessible :done, :comment
  validates :device, :task, presence: true
end
