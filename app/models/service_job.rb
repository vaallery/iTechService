# encoding: utf-8
class ServiceJob < ActiveRecord::Base

  scope :received_at, ->(period) { where created_at: period }
  scope :newest, ->{order('service_jobs.created_at desc')}
  scope :oldest, ->{order('service_jobs.created_at asc')}
  scope :done, ->{where('service_jobs.done_at IS NOT NULL').order('service_jobs.done_at desc')}
  scope :pending, ->{where(done_at: nil)}
  scope :important, ->{includes(:tasks).where('tasks.priority > ?', Task::IMPORTANCE_BOUND)}
  scope :replaced, ->{where(replaced: true)}
  scope :located_at, ->(location) { where(location_id: location.id) }
  scope :at_done, ->(user=nil) { where(location_id: user.present? ? user.done_location : Location.done.id) }
  scope :not_at_done, ->{where('service_jobs.location_id <> ?', Location.done.id)}
  scope :at_archive, ->(user=nil) { where(location_id: user.present? ? user.archive_location : Location.archive.id) }
  scope :not_at_archive, ->(user=nil) { where.not(location_id: user.present? ? user.archive_location : Location.archive.id) }
  scope :unarchived, ->{where('service_jobs.location_id <> ?', Location.archive.id)}
  scope :for_returning, -> { not_at_done.unarchived.where('((return_at - created_at) > ? and (return_at - created_at) < ? and return_at <= ?) or ((return_at - created_at) >= ? and return_at <= ?)', '30 min', '5 hour', DateTime.current.advance(minutes: 30), '5 hour', DateTime.current.advance(hours: 1)) }

  belongs_to :department, inverse_of: :service_jobs
  belongs_to :initial_department, class_name: 'Department'
  belongs_to :user, inverse_of: :service_jobs
  belongs_to :client, inverse_of: :service_jobs
  belongs_to :device_type
  belongs_to :item
  belongs_to :location
  belongs_to :receiver, class_name: 'User', foreign_key: 'user_id'
  belongs_to :sale, inverse_of: :service_job
  belongs_to :case_color
  belongs_to :carrier
  belongs_to :keeper, class_name: 'User'
  has_many :features, through: :item
  has_many :device_tasks, dependent: :destroy
  has_many :tasks, through: :device_tasks
  has_many :repair_tasks, through: :device_tasks
  has_many :repair_parts, through: :repair_tasks
  has_many :history_records, as: :object, dependent: :destroy
  has_many :device_notes, dependent: :destroy
  has_many :feedbacks, class_name: Service::Feedback.name, dependent: :destroy
  has_many :inactive_feedbacks, -> { inactive }, class_name: Service::Feedback.name, dependent: :destroy
  has_one :substitute_phone, dependent: :nullify
  has_many :viewings, class_name: ServiceJobViewing.name, dependent: :destroy

  has_and_belongs_to_many :subscribers,
                          join_table: :service_job_subscriptions,
                          association_foreign_key: :subscriber_id,
                          class_name: 'User',
                          dependent: :destroy

  accepts_nested_attributes_for :device_tasks, allow_destroy: true
  delegate :name, :short_name, :full_name, :surname, to: :client, prefix: true, allow_nil: true
  delegate :name, to: :department, prefix: true
  delegate :name, to: :location, prefix: true, allow_nil: true
  delegate :pending_substitution, to: :substitute_phone, allow_nil: true
  alias_attribute :received_at, :created_at

  attr_accessible :department_id, :comment, :serial_number, :imei, :client_id, :device_type_id, :status, :location_id, :device_tasks_attributes, :user_id, :replaced, :security_code, :notify_client, :client_notified, :return_at, :service_duration, :app_store_pass, :tech_notice, :item_id, :case_color_id, :contact_phone, :is_tray_present, :carrier_id, :keeper_id, :data_storages, :email, :substitute_phone_id, :substitute_phone_icloud_connected, :client_address, :claimed_defect, :device_condition, :client_comment, :type_of_work, :estimated_cost_of_repair

  validates_presence_of :ticket_number, :user, :client, :location, :device_tasks, :return_at, :department
  validates_presence_of :contact_phone, on: :create
  validates_presence_of :device_type, if: 'item.nil?'
  validates_presence_of :item, if: 'device_type.nil?'
  validates_presence_of :app_store_pass, if: :new_record?
  validates_uniqueness_of :ticket_number
  validates_inclusion_of :is_tray_present, in: [true, false], if: :has_imei?
  validates :substitute_phone_icloud_connected, presence: true, acceptance: true, on: :create, if: :phone_substituted?
  validate :presence_of_payment
  validate :substitute_phone_absence

  before_validation :generate_ticket_number
  before_validation :validate_security_code
  before_validation :set_user_and_location
  before_validation :validate_location
  after_save :update_qty_replaced
  after_save :update_tasks_cost
  after_update :service_job_update_announce
  after_update :deduct_spare_parts
  after_create :new_service_job_announce
  after_create :create_alert
  after_initialize :set_user_and_location
  after_initialize :set_contact_phone

  def self.search(params)
    service_jobs = ServiceJob.includes :device_tasks, :tasks

    unless (status_q = params[:status]).blank?
      service_jobs = service_jobs.send status_q if %w[done pending important].include? status_q
    end

    unless (location_q = params[:location]).blank?
      service_jobs = service_jobs.where service_jobs: {location_id: location_q}
    end

    unless (ticket_q = params[:ticket]).blank?
      service_jobs = service_jobs.where 'service_jobs.ticket_number LIKE ?', "%#{ticket_q}%"
    end

    unless (service_job_q = (params[:service_job] || params[:service_job_q])).blank?
      service_jobs = service_jobs.includes(:features).where('LOWER(features.value) LIKE :q OR LOWER(service_jobs.serial_number) LIKE :q OR LOWER(service_jobs.imei) LIKE :q', q: "%#{service_job_q.mb_chars.downcase.to_s}%").references(:features)
    end

    unless (client_q = params[:client]).blank?
      service_jobs = service_jobs.joins(:client).where 'LOWER(clients.name) LIKE :q OR LOWER(clients.surname) LIKE :q OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q', q: "%#{client_q.mb_chars.downcase.to_s}%"
    end

    service_jobs
  end

  def self.quick_search(query)
    service_jobs = ServiceJob.unarchived

    unless query.blank?
      service_jobs = service_jobs.joins(:client).where 'service_jobs.ticket_number LIKE :q OR service_jobs.contact_phone LIKE :q OR LOWER(clients.name) LIKE :q OR LOWER(clients.surname) LIKE :q', q: "%#{query.mb_chars.downcase.to_s}%"
    end

    service_jobs
  end

  def self.stale_at_done_over(term, department_id: nil)
    done_locations = Location.where(code: 'done')
    done_locations = done_locations.where(department_id: department_id) unless department_id.nil?
    storage_locations = done_locations.where(storage_term: term)
    min_term = Location.where(code: 'done').minimum(:storage_term)
    done_location_ids = Location.where(code: 'done', storage_term: min_term).pluck(:id)

    includes(:history_records)
      .where(location: storage_locations, history_records: {column_name: 'location_id', new_value: done_location_ids})
      .where('history_records.created_at < ?', term.months.ago)
  end

  def as_json(options={})
    {
      id: id,
      ticket_number: ticket_number,
      user_name: user_short_name,
      device_type: type_name,
      imei: imei,
      serial_number: serial_number,
      status: status,
      comment: comment,
      at_done: at_done?,
      in_archive: in_archive?,
      location: location&.name,
      client: {
        id: client_id,
        name: client&.short_name,
        phone: client&.phone_number
      },
      contact_phone: contact_phone,
      tasks: device_tasks,
      total_cost: tasks_cost,
      case_color: case_color.as_json(only: [:name, :color])
    }
  end

  def type_name
    item.present? ? item.name : (device_type&.full_name || '-')
  end

  def device_short_name
    item&.product_group_name
  end

  def imei
    item&.imei || self['imei']
  end

  def serial_number
    item&.serial_number || self['serial_number']
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
    if item.present?
      sn = item.serial_number
      imei = item.imei
    else
      sn = self.serial_number.presence || '?'
      imei = self.imei.presence || '?'
    end
    [type_name, sn, imei].join(' / ')
  end

  def done?
    pending_tasks.empty?
  end
  
  def pending?
    !done?
  end

  def transferred?
    initial_department_id.present? && department_id != initial_department_id
  end

  def done_tasks
    device_tasks.done
  end

  def undone_tasks
    device_tasks.undone
  end

  def processed_tasks
    device_tasks.processed
  end

  def pending_tasks
    device_tasks.pending
  end
  
  def is_important?
    tasks.important.any?
  end
  
  def progress
    "#{processed_tasks.count} / #{device_tasks.count}"
  end
  
  def progress_pct
    (processed_tasks.count * 100.0 / device_tasks.count).to_i
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
    if (rec = history_records.movements.order_by_newest.first).present?
      rec.created_at
    else
      nil
    end
  end

  def moved_by
    if (rec = history_records.movements.order_by_newest.first).present?
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
    location.try(:is_done?)
    # reload.location.try(:is_done?)
  end

  def in_archive?
    location.try(:is_archive?)
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
    if self.location.is_repair?
      recipient_ids = User.active.map &:id
    else
      recipient_ids = User.active.not_technician.map &:id
    end
    announcement = Announcement.create_with(active: true, recipient_ids: recipient_ids).find_or_create_by(kind: 'device_return', content: self.id.to_s)
    PrivatePub.publish_to '/service_jobs/returning_alert', announcement_id: announcement.id
  end

  def create_filled_sale
    sale_attributes = { client_id: client_id, store_id: User.current.retail_store.id, sale_items_attributes: {} }
    device_tasks.paid.each_with_index do |device_task, index|
      sale_item_attributes = {device_task_id: device_task.id, item_id: device_task.item.id, price: device_task.cost.to_f, quantity: 1}
      sale_attributes[:sale_items_attributes].store index.to_s, sale_item_attributes
      #new_sale.sale_items.build item_id: device_task.item.id, price: device_task.cost, quantity: 1
    end
    new_sale = create_sale sale_attributes
    update_attribute :sale_id, new_sale.id
    new_sale
  end

  def contact_phone_none?
    contact_phone.blank? or contact_phone == '-'
  end

  def data_storages
    self[:data_storages]&.split(',') || []
  end

  def data_storages=(new_value)
    if new_value.respond_to? :join
      super new_value.join(',')
    else
      super
    end
  end

  def note
    device_notes.last&.content&.presence || comment
  end

  def substitute_phone_id
    substitute_phone&.id
  end

  def substitute_phone_id=(new_id)
    if new_id.present?
      new_substitute_phone = SubstitutePhone.find new_id
      self.substitute_phone = new_substitute_phone if new_substitute_phone.service_job_id.nil?
    else
      self.substitute_phone = nil
    end
  end

  def phone_substituted?
    substitute_phone.present?
  end

  def work_order_filled?
    device_condition.present?
  end

  # TODO: correct
  def archived_at
    return unless in_archive?
    moved_at
  end

  private

  def generate_ticket_number
    if self.ticket_number.blank?
      begin number = UUIDTools::UUID.random_create.hash.to_s end while ServiceJob.exists? ticket_number: number
      self.ticket_number = Setting.ticket_prefix + number
    end
  end

  def update_qty_replaced
    if changed_attributes[:replaced].present? and replaced != changed_attributes[:replaced]
      qty_replaced = ServiceJob.replaced.where(device_type_id: self.device_type_id)
      self.device_type.update_attribute :qty_replaced, qty_replaced
    end
  end

  def update_tasks_cost
    if location_id_changed? and location.is_done? and repair_tasks.present?
      repair_tasks.each do |repair_task|
        if repair_task.device_task.cost == 0
          repair_task.device_task.update_attribute(:cost, repair_task.device_task.repair_cost)
        end
      end
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
    self.department_id ||= Department.current.try(:id)
  end

  def validate_location
    if self.location.present?
      old_location = changed_attributes['location_id'].present? ? Location.find(changed_attributes['location_id']) : nil

      if self.location.is_done? and self.pending?
        self.errors.add :location_id, I18n.t('service_jobs.errors.pending_tasks')
      end

      if self.location.is_done? and self.notify_client? and self.client_notified.nil?
        self.errors.add :client_notified, I18n.t('service_jobs.errors.client_notification')
      end

      if self.location.is_archive? and !old_location.try(:is_done?)
        self.errors.add :location_id, I18n.t('service_jobs.errors.not_done')
      end

      if (old_location.try(:is_archive?) && User.current.not_admin?) ||
         (self.location.is_warranty? && !old_location.try(:is_repair?)) ||
         (location.is_special? && User.current.not_admin?) ||
         (old_location&.is_special? && !User.current.superadmin?)
        self.errors.add :location_id, I18n.t('service_jobs.errors.not_allowed')
      end

      if self.location.is_repair_notebooks? and old_location.present?
        MovementMailer.notice(self).deliver_later
      end

      #if User.current.not_admin? and old_location != User.current.location
      #  self.errors.add :location_id, I18n.t('service_jobs.movement_error_not_allowed')
      #end
    end
  end

  def new_service_job_announce
    # PrivatePub.publish_to '/service_jobs/new', service_job: self if Rails.env.production?
  end

  def service_job_update_announce
    if changed_attributes['location_id'].present?
      if self.at_done?
        Announcement.find_by_kind_and_content('device_return', self.id.to_s).try(:destroy)
        ServiceJobsMailer.done_notice(self.id).deliver_later if email.present?
      end
    end
    # PrivatePub.publish_to '/service_jobs/update', service_job: self if changed_attributes['location_id'].present? and Rails.env.production?
  end

  def create_alert
    # service duration in minutes
    duration = (self.return_at.to_i - self.created_at.to_i)/60
    if duration > 30
      alert_times = []
      alert_times.push self.return_at.advance minutes: -30 if duration < 300
      alert_times.push self.return_at.advance hours: -1 if duration >= 300
      alert_times.push self.return_at.advance days: -1 if duration > 1440
      # TODO: переделать
      # alert_times.each { |alert_time| self.delay(run_at: alert_time).returning_alert }
    end
  end

  def presence_of_payment
    is_valid = true
    if location_id_changed? && location.is_archive?
      if tasks_cost > 0
        if sale.nil? or !sale.is_posted?
          errors.add :base, :not_paid
        end
      end
    end
    is_valid
  end

  def substitute_phone_absence
    if location_id_changed? && location.is_archive?
      if substitute_phone.present?
        errors.add :base, :substitute_phone_not_received
      end
    end
  end

  def set_contact_phone
    self.contact_phone = self.client.try(:contact_phone) || '-' if self.contact_phone.blank?
  end

  def deduct_spare_parts
    if location_id_changed? and location.is_done?
      repair_parts.all? do |repair_part|
        repair_part.deduct_spare_parts
      end
    end
  end
end
