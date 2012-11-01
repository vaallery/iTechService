class Task < ActiveRecord::Base
  has_many :devices, through: :devices_tasks
  attr_accessible :cost, :duration, :name
end
