class DeviceTask < ActiveRecord::Base
  belongs_to :device
  belongs_to :task
  attr_accessible :done, :comment, :cost, :device_id, :task_id
  validates :task_id, presence: true
  
  scope :ordered, joins(:task).order("done asc, tasks.priority desc")
  
  after_initialize {|dt| dt.cost = task_cost}
  
  before_save do |dt|
    unless (old_done = changed_attributes['done']).nil?
      if self.done and !old_done
        done_at_val = Time.now
      elsif !self.done and old_done
        done_at_val = nil
      end
      self.done_at = done_at_val
    end
  end
  
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