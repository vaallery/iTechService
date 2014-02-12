class DeviceTask < ActiveRecord::Base

  scope :ordered, joins(:task).order('done asc, tasks.priority desc')
  scope :done, where(done: true)
  scope :pending, where(done: false)
  scope :tasks_for, lambda { |user| joins(:device, :task).where(devices: {location_id: user.location_id}, tasks: {role: user.role}) }

  belongs_to :device
  belongs_to :task
  has_many :history_records, as: :object
  has_many :repair_tasks
  has_many :repair_parts, through: :repair_tasks
  accepts_nested_attributes_for :device, reject_if: proc { |attr| attr['tech_notice'].blank? }
  accepts_nested_attributes_for :repair_tasks

  delegate :name, :role, :is_important?, :is_actual_for?, to: :task, allow_nil: true
  delegate :client_presentation, to: :device, allow_nil: true
  delegate :is_repair, to: :task, allow_nil: true
  attr_accessible :done, :comment, :user_comment, :cost, :task, :device, :device_id, :task_id, :task, :device_attributes, :repair_tasks_attributes
  validates :task, :cost, presence: true
  validates :cost, numericality: true
  validates_associated :repair_tasks
  after_initialize { self.done ||= false }
  after_commit :update_device_done_attribute
  after_commit :deduct_defected if :is_repair

  before_save do |dt|
    old_done = changed_attributes['done']
    if dt.done and (!old_done or old_done.nil?)
      dt.done_at = DateTime.current
    elsif !dt.done and old_done
      dt.done_at = nil
    end
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

  def is_repair?
    # TODO task.is_repair?
    true
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

  private

  def update_device_done_attribute
    done_time = self.device.done? ? self.device.device_tasks.maximum(:done_at).getlocal : nil
    self.device.update_attribute :done_at, done_time
  end

  def deduct_defected
    old_done = changed_attributes['done']
    if self.done and (!old_done or old_done.nil?)
      self.repair_parts.each { |repair_part| repair_part.deduct_defected }
    end
  end

end