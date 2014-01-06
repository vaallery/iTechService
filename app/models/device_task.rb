class DeviceTask < ActiveRecord::Base
  belongs_to :device
  belongs_to :task
  has_many :history_records, as: :object
  accepts_nested_attributes_for :device, reject_if: proc { |attr| attr['tech_notice'].blank? }
  attr_accessible :done, :comment, :user_comment, :cost, :task, :device, :device_id, :task_id, :task, :device_attributes
  validates :task, :cost, presence: true
  validates :cost, numericality: true # except repair
  delegate :role, to: :task

  scope :ordered, joins(:task).order("done asc, tasks.priority desc")
  delegate :name, :role, :is_important?, :is_actual_for?, to: :task, allow_nil: true
  delegate :client_presentation, to: :device, allow_nil: true

  scope :ordered, joins(:task).order('done asc, tasks.priority desc')
  scope :done, where(done: true)
  scope :pending, where(done: false)
  scope :tasks_for, lambda { |user| joins(:device, :task).where(devices: {location_id: user.location_id}, tasks: {role: user.role}) }
  
  before_save do |dt|
    dt.done = false if dt.done.nil?
    old_done = changed_attributes['done']
    if dt.done and (!old_done or old_done.nil?)
      dt.done_at = Time.now
    elsif !dt.done and old_done
      dt.done_at = nil
    end
  end
  
  after_commit do |dt|
    done_time = dt.device.done? ? dt.device.device_tasks.maximum(:done_at).getlocal : nil
    dt.device.update_attribute :done_at, done_time
  end

  def as_json(options={})
    {
      id: id,
      name: name,
      done: done,
      cost: cost,
      comment: comment,
      user_comment: user_comment
    }
  end

  def task_name
    task.try :name
  end

  def task_cost
    task.try(:cost) || 0
  end
  
  def task_duration
    task.try :duration
  end

  def device_presentation
    device.present? ? device.presentation : ''
  end

  def performer
    if (completions = history_records.task_completions).any?
      completions.last.try :user
    else
      nil
    end
  end

  def performer_name
    performer.present? ? performer.short_name : ''
  end

  #def validate_device_tasks
  #  roles = []
  #  device_tasks.each do |dt|
  #    if roles.include? dt.role and dt.role == 'software'
  #      self.errors.add(:device_tasks, I18n.t('devices.device_tasks_error'))
  #    else
  #      roles << dt.role
  #    end
  #  end
  #end

end