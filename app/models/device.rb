# encoding: utf-8
class Device < ActiveRecord::Base

  belongs_to :user, inverse_of: :devices
  belongs_to :client, inverse_of: :devices
  belongs_to :device_type
  belongs_to :location
  belongs_to :receiver, class_name: 'User', foreign_key: 'user_id'
  has_many :device_tasks, dependent: :destroy
  has_many :tasks, through: :device_tasks
  has_many :history_records, as: :object, dependent: :destroy
  attr_accessible :comment, :serial_number, :imei, :client, :client_id, :device_type, :device_type_id, :status,
                  :location_id, :device_tasks_attributes, :user, :user_id, :replaced, :security_code
  accepts_nested_attributes_for :device_tasks
  #attr_accessible :created_at, :updated_at, :done_at

  validates :ticket_number, :client_id, :device_type_id, :location_id, presence: true
  validates :device_tasks, presence: true
  validates :ticket_number, uniqueness: true
  validates :imei, length: {is: 15}, allow_blank: true
  validates_associated :device_tasks
  
  before_validation :generate_ticket_number
  before_validation :check_device_type
  before_validation :check_security_code
  before_validation :set_user_and_location
  before_validation :validate_location
  after_save :update_qty_replaced

  #scope :ordered, order("devices.done_at desc, created_at asc")
  scope :ordered, order('created_at desc')
  scope :done, where('devices.done_at IS NOT NULL').order('devices.done_at desc')
  scope :pending, where(done_at: nil)
  scope :important, includes(:tasks).where('tasks.priority > ?', Task::IMPORTANCE_BOUND)
  scope :replaced, where(replaced: true)
  scope :located_at, lambda {|location| where(location_id: location.id)}
  scope :at_done, where(location_id: Location.find_by_name('Готово'))
  scope :at_archive, where(location_id: Location.find_by_name('Архив'))
  #scope :archived_at

  after_initialize :set_user_and_location
  
  def type_name
    device_type.try(:full_name) || '-'
  end

  def location_name
    location.try(:full_name) || '-'
  end
  
  def client_name
    client.try(:name) || '-'
  end

  def client_short_name
    client.try(:short_name) || '-'
  end

  def client_phone
    client.try(:phone_number) || '-'
  end

  def client_presentation
    client.try(:presentation) || '-'
  end

  def user_name
    (user || User.current).name
  end

  def user_short_name
    (user || User.current).short_name
  end

  def user_full_name
    (user || User.current).full_name
  end

  def presentation
    serial_number.blank? ? type_name : [type_name, serial_number].join(' / ')
  end
  
  def done?
    pending_tasks.empty?
  end
  
  def pending?
    !done?
  end
  
  def self.search params
    devices = Device.includes :device_tasks, :tasks
    
    unless (status_q = params[:status]).blank?
      devices = devices.send status_q if %w[done pending important].include? status_q
    end

    unless (location_q = params[:location]).blank?
      devices = devices.where devices: {location_id: location_q}
    end
    
    unless (ticket_q = params[:ticket]).blank?
      devices = devices.where 'devices.ticket_number LIKE ?', "%#{ticket_q}%"
    end
    
    unless (device_q = params[:device]).blank?
      devices = devices.where 'LOWER(devices.serial_number) LIKE ?', "%#{device_q.mb_chars.downcase.to_s}%"
    end

    unless (device_q = params[:device_q]).blank?
      devices = devices.where 'LOWER(devices.serial_number) LIKE ?', "%#{device_q.mb_chars.downcase.to_s}%"
    end

    unless (client_q = params[:client]).blank?
      devices = devices.joins(:client).where 'LOWER(clients.name) LIKE :q OR LOWER(clients.surname) LIKE :q
                                              OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q',
                                              q: "%#{client_q.mb_chars.downcase.to_s}%"
    end
    
    devices
  end
  
  def done_tasks
    device_tasks.where done: true
  end
  
  def pending_tasks
    device_tasks.where done: false
  end
  
  def is_important?
    tasks.important.any?
  end
  
  def progress
    "#{done_tasks.count} / #{device_tasks.count}"
  end
  
  def progress_pct
    (done_tasks.count * 100.0 / device_tasks.count).to_i
  end

  def tasks_cost
    device_tasks.sum :cost
  end

  def status
    #done? ? I18n.t('done') : I18n.t('undone')
    #location.try(:name) == 'Готово' ? I18n.t('done') : I18n.t('undone')
    location.try(:name) == 'Готово' ? 'done' : 'undone'
  end

  def status_info
    {
      #client: client_presentation,
      #device_type: type_name,
      status: status
    }
  end

  def is_iphone?
    device_type.is_iphone? if device_type.present?
  end

  def has_imei?
    device_type.has_imei? if device_type.present?
  end

  def moved_at
    if (rec = history_records.where(column_name: 'location_id').order('updated_at desc').first).present?
      rec.updated_at
    else
      nil
    end
  end

  def moved_by
    if (rec = history_records.where(column_name: 'location_id').order('updated_at desc').first).present?
      rec.user
    else
      nil
    end
  end

  def is_actual_for? user
    device_tasks.any?{|t|t.is_actual_for? user}
  end

  def movement_history
    records = history_records.where(column_name: 'location_id').order('created_at desc')
    records.map do |record|
      [record.created_at, record.new_value, record.user_id]
    end
  end

  private

  def generate_ticket_number
    if self.ticket_number.blank?
      begin number = UUIDTools::UUID.random_create.hash.to_s end while Device.exists? ticket_number: number
      self.ticket_number = number
    end
  end

  def check_device_type
    self.device_type_id = DeviceType.find_or_create_by_name(type_name).id
  end

  def update_qty_replaced
    if changed_attributes[:replaced].present? and replaced != changed_attributes[:replaced]
      qty_replaced = Device.replaced.where(device_type_id: self.device_type_id)
      self.device_type.update_attribute :qty_replaced, qty_replaced
    end
  end

  def check_security_code
    if is_iphone? and security_code.blank?
      errors.add :security_code, I18n.t('.errors.messages.empty')
    end
  end

  def set_user_and_location
    self.location_id ||= User.try(:current).try(:location_id)
    self.user_id ||= User.try(:current).try(:id)
  end

  def validate_location
    old_location = changed_attributes['location_id'].present? ? Location.find(changed_attributes['location_id']) : nil
    if self.location.is_done? and self.pending?
      self.errors.add :location_id, I18n.t('devices.movement_error')
    end
    if self.location.is_archive? and !old_location.try(:is_repair?)
      self.errors.add :location_id, I18n.t('devices.movement_error_not_done')
    end
    if old_location.is_archive? and User.current.not_admin?
      self.errors.add :location_id, I18n.t('devices.movement_error_not_allowed')
    end
    if self.location.is_warranty? and old_location.try(:is_repair?)
      self.errors.add :location_id, I18n.t('devices.movement_error_not_allowed')
    end
  end

end
