class Setting < ActiveRecord::Base

  attr_accessible :name, :presentation, :value, :value_type
  validates :name, :value_type, presence: true
  validates_uniqueness_of :name

  VALUE_TYPES = ['boolean', 'integer', 'string', 'text']

  def self.setting_value(setting_name)
    if (setting = Setting.find_by_name(setting_name)).present?
      setting.value
    else
      nil
    end
  end

  def self.ticket_prefix
    (setting = Setting.find_by_name('ticket_prefix')).present? ? setting.value : 'VL'
  end

  def self.get_value(name)
    (setting = Setting.find_by_name(name.to_s)).present? ? setting.value : ''
  end

end
