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

  attr_accessible :comment, :serial_number, :imei, :client, :client_id, :device_type_id, :status, :location_id, :device_tasks_attributes, :user, :user_id, :replaced, :security_code, :notify_client, :client_notified, :return_at, :service_duration, :app_store_pass, :tech_notice
  accepts_nested_attributes_for :device_tasks
  attr_accessor :service_duration

  delegate :name, :short_name, :full_name, to: :client, prefix: true, allow_nil: true

  validates_presence_of :ticket_number, :client, :device_type, :location, :device_tasks, :return_at
  validates_presence_of :app_store_pass, if: :new_record?
  validates_uniqueness_of :ticket_number
  validates_length_of :imei, is: 15, allow_blank: true
  validates_associated :device_tasks
  
  before_validation :generate_ticket_number
  before_validation :validate_security_code
  before_validation :set_user_and_location
  before_validation :validate_location

  after_save :update_qty_replaced
  after_update :device_update_announce
  after_create :new_device_announce
  after_create :create_alert

  scope :newest, order('created_at desc')
  scope :oldest, order('created_at asc')
  scope :done, where('devices.done_at IS NOT NULL').order('devices.done_at desc')
  scope :pending, where(done_at: nil)
  scope :important, includes(:tasks).where('tasks.priority > ?', Task::IMPORTANCE_BOUND)
  scope :replaced, where(replaced: true)
  scope :located_at, lambda {|location| where(location_id: location.id)}
  scope :at_done, where(location_id: Location.done_id)
  scope :not_at_done, where('devices.location_id <> ?', Location.done_id)
  scope :at_archive, where(location_id: Location.archive_id)
  scope :unarchived, where('devices.location_id <> ?', Location.archive_id)
  scope :for_returning, -> { not_at_done.unarchived.where('((return_at - created_at) > ? and (return_at - created_at) < ? and return_at <= ?) or ((return_at - created_at) >= ? and return_at <= ?)', '30 min', '5 hour', DateTime.current.advance(minutes: 30), '5 hour', DateTime.current.advance(hours: 1)) }

  after_initialize :set_user_and_location

  def as_json(options={})
    {
      id: id,
      device_type: type_name,
      imei: imei,
      serial_number: serial_number,
      status: status,
      comment: comment,
      at_done: at_done?,
      in_archive: in_archive?,
      location: location.try(:name),
      client: {
        id: client_id,
        name: client.short_name,
        phone: client.phone_number
      },
      tasks: device_tasks,
      total_cost: tasks_cost
    }
  end

  def type_name
    device_type.try(:full_name) || '-'
  end

  def location_name
    location.try(:full_name) || '-'
  end
  
  def client_phone
    client.try(:phone_number) || '-'
  end

  def client_contact_phone
    client.contact_phone.blank? ? client.full_phone_number : client.contact_phone
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
  
  def self.search(params)
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

    unless (device_q = (params[:device] || params[:device_q])).blank?
      devices = devices.where 'LOWER(devices.serial_number) LIKE :q OR LOWER(devices.imei) LIKE :q', q: "%#{device_q.mb_chars.downcase.to_s}%"
    end

    unless (client_q = params[:client]).blank?
      devices = devices.joins(:client).where 'LOWER(clients.name) LIKE :q OR LOWER(clients.surname) LIKE :q OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q', q: "%#{client_q.mb_chars.downcase.to_s}%"
    end
    
    devices
  end
  
  def done_tasks
    device_tasks.done
  end
  
  def pending_tasks
    device_tasks.pending
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
    location.try(:name) == 'Готово' ? 'done' : 'undone'
  end

  def status_info
    {
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
    if (rec = history_records.movements.order('updated_at desc').first).present?
      rec.updated_at
    else
      nil
    end
  end

  def moved_by
    if (rec = history_records.movements.order('updated_at desc').first).present?
      rec.user
    else
      nil
    end
  end

  def is_actual_for? user
    device_tasks.any?{|t|t.is_actual_for? user}
  end

  def movement_history
    records = history_records.movements.order('created_at desc')
    records.map do |record|
      [record.created_at, record.new_value, record.user_id]
    end
  end

  def at_done?
    location.is_done?
  end

  def in_archive?
    location.is_archive?
  end

  def barcode_num
    '0'*(12-ticket_number.length) + ticket_number
  end

  def service_duration=(duration)
    if duration.is_a? String
      array = duration.split '.'
      array.map! { |d| d.to_i }
      now = DateTime.current.change sec: 0
      self.return_at = now.advance minutes: array[-1], hours: array[-2], days: array[-3]
    end
  end

  def returning_alert
    recipient_ids = User.active.map { |user| user.id }
    announcement = Announcement.create kind: 'device_return', active: true, recipient_ids: recipient_ids, content: self.id
    PrivatePub.publish_to '/devices/returning_alert', announcement_id: announcement.id
  end

  private

  def generate_ticket_number
    if self.ticket_number.blank?
      begin number = UUIDTools::UUID.random_create.hash.to_s end while Device.exists? ticket_number: number
      self.ticket_number = Setting.ticket_prefix + number
    end
  end

  def update_qty_replaced
    if changed_attributes[:replaced].present? and replaced != changed_attributes[:replaced]
      qty_replaced = Device.replaced.where(device_type_id: self.device_type_id)
      self.device_type.update_attribute :qty_replaced, qty_replaced
    end
  end

  def validate_security_code
    if is_iphone? and security_code.blank?
      errors.add :security_code, I18n.t('.errors.messages.empty')
    end
  end

  def set_user_and_location
    self.location_id ||= User.try(:current).try(:location_id)
    self.user_id ||= User.try(:current).try(:id)
  end

  def validate_location
    if self.location.present?
      old_location = changed_attributes['location_id'].present? ? Location.find(changed_attributes['location_id']) : nil
      if self.location.is_done? and self.pending?
        self.errors.add :location_id, I18n.t('devices.errors.pending_tasks')
      end
      if self.location.is_done? and self.notify_client? and self.client_notified.nil?
        self.errors.add :client_notified, I18n.t('devices.errors.client_notification')
      end
      if self.location.is_archive? and !old_location.try(:is_done?)
        self.errors.add :location_id, I18n.t('devices.errors.not_done')
      end
      if old_location.try(:is_archive?) and User.current.not_admin?
        self.errors.add :location_id, I18n.t('devices.errors.not_allowed')
      end
      if self.location.is_warranty? and !old_location.try(:is_repair?)
        self.errors.add :location_id, I18n.t('devices.errors.not_allowed')
      end
      if self.location.is_popov? and old_location.present?
        MovementMailer.notice(self).deliver
      end

      #if User.current.not_admin? and old_location != User.current.location
      #  self.errors.add :location_id, I18n.t('devices.movement_error_not_allowed')
      #end
    end
  end

  def new_device_announce
    PrivatePub.publish_to '/devices/new', device: self if Rails.env.production?
  end

  def device_update_announce
    PrivatePub.publish_to '/devices/update', device: self if changed_attributes[:location_id].blank? and Rails.env.production?
  end

  def create_alert
    # service duration in minutes
    duration = (self.return_at.to_i - self.created_at.to_i)/60
    if duration > 30
      alert_times = []
      alert_times.push self.return_at.advance minutes: -30 if duration < 300
      alert_times.push self.return_at.advance hours: -1 if duration >= 300
      alert_times.push self.return_at.advance days: -1 if duration > 1440
      alert_times.each { |alert_time| self.delay(run_at: alert_time).returning_alert }
    end
  end

end
