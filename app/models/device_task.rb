class DeviceTask < ActiveRecord::Base
  belongs_to :device
  belongs_to :task
  has_many :history_records, as: :object
  attr_accessible :done, :comment, :cost, :task, :device, :device_id, :task_id
  validates :task_id, presence: true
  
  scope :ordered, joins(:task).order("done asc, tasks.priority desc")
  scope :done, where(done: true)
  scope :pending, where(done: false)
  
  after_initialize {|dt| dt.cost = task_cost}
  
  before_save do |dt|
    old_done = changed_attributes['done']
    if self.done and (!old_done or old_done.nil?)
      done_at_val = Time.now
    elsif !self.done and old_done
      done_at_val = nil
    end
    self.done_at = done_at_val
  end
  
  after_commit do |dt|
    done_time = device.done? ? device.device_tasks.maximum(:done_at).getlocal : nil
    device.update_attribute :done_at, done_time
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
  
  def is_important?
    task.is_important?
  end
  
end