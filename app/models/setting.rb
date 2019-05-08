class Setting < ActiveRecord::Base

  DEFAULT_SETTINGS = {
      address: 'string',
      address_for_check: 'string',
      contact_phone: 'string',
      contact_phone_short: 'string',
      data_storage_qty: 'integer',
      duck_plan: 'string',
      duck_plan_url: 'string',
      email: 'string',
      emails_for_acts: 'string',
      emails_for_orders: 'string',
      emails_for_sales_report: 'string',
      legal_address: 'string',
      meda_menu_database: 'string',
      ogrn: 'string',
      organization: 'string',
      schedule: 'string',
      site: 'string',
      ticket_prefix: 'string',
      service_tasks_models: 'json',
      sms_gateway_lines_qty: 'integer'
  }

  VALUE_TYPES = %w[boolean integer string text json]

  default_scope {order('settings.name asc')}
  scope :for_department, ->(department) { where(department_id: department.is_a?(Department) ? department.id : department) }

  belongs_to :department
  delegate :name, to: :department, prefix: true, allow_nil: true

  attr_accessible :name, :presentation, :value, :value_type, :department_id
  validates :name, :value_type, presence: true
  validates_uniqueness_of :name, scope: :department_id
  validate :json_value_correct

  class << self
    def get_value(name, department = Department.current)
      setting = Setting.for_department(department).find_by_name(name.to_s) || Setting.find_by(department_id: nil, name: name.to_s)
      setting.present? ? setting.value : ''
    end

    def ogrn
      Setting.find_by(name: 'ogrn')&.value
    end

    def ticket_prefix(department=nil)
      (setting = Setting.for_department(department).find_by_name('ticket_prefix')).present? ? setting.value : '25'
    end

    def duck_plan(department)
      Setting.for_department(department).find_by_name('duck_plan').try :value
    end

    def duck_plan_url(department)
      Setting.for_department(department).find_by_name('duck_plan_url').try :value
    end

    def data_storage_qty(department = nil)
      Setting.get_value('data_storage_qty', department).to_i
    end

    def schedule(department = nil)
      department ||= Department.current
      Setting.for_department(department).find_by(name: 'schedule')&.value
    end

    def emails_for_orders
      Setting.get_value 'emails_for_orders'
    end

    def meda_menu_database
      Setting.for_department(Department.current).find_by(name: 'meda_menu_database')&.value
    end

    def service_tasks_models
      Setting.find_by(name: 'service_tasks_models')&.value
      value = Setting.find_by(name: 'service_tasks_models')&.value
      return unless value
      JSON.parse value
    end

    def sms_gateway_lines_qty
      (Setting.find_by(name: 'sms_gateway_lines_qty')&.value || 1).to_i
    end

    private

    def parse_value(value)
      begin
        JSON.parse value
      rescue => error
        return error
      end
    end
  end

  private

  def json_value_correct
    return unless value_type == 'json' && !value.nil?

    begin
      JSON.parse value
      return true
    rescue => error
      errors.add :value, error.message
    end
  end
end
