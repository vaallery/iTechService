class DevicesTasks < ActiveRecord::Base
  belongs_to :device
  belongs_to :task
  attr_accessible :done, :comment
end
