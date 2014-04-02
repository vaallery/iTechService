class Setting < ActiveRecord::Base

  DEFAULT_SETTINGS = {
      ticket_prefix: 'string',
      duck_plan: 'string',
      duck_plan_url: 'string',
      address_for_check: 'string'
  }

  default_scope order('settings.id asc')
  scope :for_department, lambda { |department| where(department_id: department.is_a?(Department) ? department.id : department) }

  belongs_to :department
  delegate :name, to: :department, prefix: true, allow_nil: true

  attr_accessible :name, :presentation, :value, :value_type, :department_id
  validates :name, :value_type, presence: true
  validates_uniqueness_of :name

  VALUE_TYPES = ['boolean', 'integer', 'string', 'text']

  def self.ticket_prefix(department=nil)
    (setting = Setting.for_department(department).find_by_name('ticket_prefix')).present? ? setting.value : '25'
  end

  def self.get_value(name, department=nil)
    (setting = Setting.for_department(department).find_by_name(name.to_s) || Setting.where(department_id: nil, name: name.to_s)).present? ? setting.value : ''
  end

  def self.duck_plan(department)
    Setting.for_department(department).find_by_name('duck_plan').try :value
  end

  def self.duck_plan_url(department)
    Setting.for_department(department).find_by_name('duck_plan_url').try :value
  end

end
