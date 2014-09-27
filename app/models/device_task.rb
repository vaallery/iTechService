class DeviceTask < ActiveRecord::Base

  scope :ordered, joins(:task).order('done asc, tasks.priority desc')
  scope :pending, where(done: 0)
  scope :done, where(done: 1)
  scope :undone, where(done: 2)
  scope :tasks_for, lambda { |user| joins(:device, :task).where(devices: {location_id: user.location_id}, tasks: {role: user.role}) }
  scope :paid, where('device_tasks.cost > 0')

  belongs_to :device
  belongs_to :task
  belongs_to :performer, class_name: 'User'
  has_many :history_records, as: :object
  has_many :repair_tasks
  has_many :repair_parts, through: :repair_tasks
  has_one :sale_item, inverse_of: :device_task
  accepts_nested_attributes_for :device, reject_if: proc { |attr| attr['tech_notice'].blank? }
  accepts_nested_attributes_for :repair_tasks, allow_destroy: true

  delegate :name, :role, :is_important?, :is_actual_for?, :is_repair?, :item, to: :task, allow_nil: true
  delegate :client_presentation, to: :device, allow_nil: true
  delegate :department, :user, to: :device

  attr_accessible :done, :done_at, :comment, :user_comment, :cost, :task, :device, :device_id, :task_id, :performer_id, :task, :device_attributes, :repair_tasks_attributes
  validates :task, :cost, presence: true
  validates :cost, numericality: true
  validate :valid_repair if :is_repair?
  validates_associated :repair_tasks
  after_commit :update_device_done_attribute
  after_save :deduct_spare_parts if :is_repair?
  after_initialize :set_performer

  before_save do |dt|
    old_done = dt.done_was
    if dt.done != 0 and old_done == 0
      dt.done_at = DateTime.current
      dt.performer_id = User.current.try(:id)
    elsif dt.done != 1 and old_done == 1
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

  def repair_cost
    repair_tasks.sum(:price)
  end

  def done_s
    %w(pending done undone)[done]
  end

  def pending?
    done == 0
  end

  def done?
    done == 1
  end

  def undone?
    done == 2
  end

  private

  def update_device_done_attribute
    done_time = self.device.done? ? self.device.device_tasks.maximum(:done_at).getlocal : nil
    self.device.update_attribute :done_at, done_time
  end

  def deduct_spare_parts
    repair_parts.each { |repair_part| repair_part.deduct_spare_parts } if done_changed?
  end

  def valid_repair
    is_valid = true
    if done_changed?
      if done_was == 1
        errors.add :done, :already_done
        is_valid = false
      else
        repair_parts.each do |repair_part|
          if repair_part.store.present?
            if repair_part.store_item(repair_part.store).quantity < (repair_part.quantity + repair_part.defect_qty)
              errors[:base] << I18n.t('device_tasks.errors.insufficient_spare_parts', name: repair_part.name)
              is_valid = false
            end
          else
            errors.add :base, :no_spare_parts_store
            is_valid = false
          end
        end
        if repair_parts.sum(:defect_qty) > 0 and (User.current.try(:defect_sp_store).nil?)
          errors.add :base, :no_defect_store
          is_valid = false
        end
      end
    end
    is_valid
  end

  def set_performer
    if performer_id.nil? and done and (user = history_records.task_completions.order_by_newest.where(new_value: true).first.try(:user)).present?
    #if done and (user = history_records.task_completions.where(user_id: 1..10000).order_by_newest.first.user).present?
      update_attribute :performer_id, user.id
    end
  end

end