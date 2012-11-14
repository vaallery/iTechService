class DeviceTask < ActiveRecord::Base
  belongs_to :device
  belongs_to :task
  attr_accessible :done, :comment, :task_cost, :device_id, :task_id
  validates :task_id, presence: true
  
  scope :ordered, joins(:task).order("done asc, tasks.priority desc")
  
  after_initialize {|dt| dt.cost = task_cost}
  
  #before_save do |dt|
  #  done_at = 
  #end
  
  def task_name
    task.try :name
  end
  
  def task_cost
    task.try :cost
  end
  
  def task_duration
    task.try :duration
  end
end