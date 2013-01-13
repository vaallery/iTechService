class Device < ActiveRecord::Base
  
  belongs_to :client, inverse_of: :devices
  belongs_to :device_type
  belongs_to :location
  belongs_to :receiver, class_name: 'User', foreign_key: 'user_id'
  has_many :device_tasks, dependent: :destroy
  has_many :tasks, through: :device_tasks
  has_many :history_records, as: :object
  attr_accessible :comment, :serial_number, :emei, :client, :client_id, :device_type, :device_type_id,
                  :location_id, :device_tasks_attributes, :user, :user_id, :replaced, :security_code
  accepts_nested_attributes_for :device_tasks
  #attr_accessible :created_at, :updated_at, :done_at

  validates :ticket_number, :client_id, :device_type_id, :location_id, presence: true
  validates :ticket_number, uniqueness: true
  validates_associated :device_tasks
  
  before_validation :generate_ticket_number
  before_validation :check_device_type
  before_validation :check_security_code
  after_save :update_qty_replaced

  scope :ordered, order("devices.done_at desc, created_at asc")#, tasks.priority desc")
  scope :done, where('devices.done_at IS NOT NULL')
  scope :pending, where(done_at: nil)
  scope :important, includes(:tasks).where('tasks.priority > ?', Task::IMPORTANCE_BOUND)
  scope :replaced, where(replaced: true)

  after_initialize do |device|
    device.location_id ||= User.try(:current).try :location_id
    device.user_id ||= User.try(:current).try :id
  end
  
  def type_name
    device_type.try :full_name
  end

  def location_name
    location.try :full_name
  end
  
  def client_name
    client.try :name
  end
  
  def client_phone
    client.try :phone_number
  end

  def client_presentation
    client.name_phone
  end

  def user_name
    user.try :name
  end
  
  def presentation
    serial_number.blank? ? type_name : [type_name, serial_number].join(' / ')
  end
  
  def done?
    device_tasks.pending.empty?
  end
  
  def pending?
    !done?
  end
  
  def self.search params
    devices = Device.includes :device_tasks, :tasks
    
    unless (status_q = params[:status]).blank?
      devices = devices.send status_q if %w[done pending important].include? status_q
      #case status
      #  when 'done' then devices = devices.done
      #  when 'pending' then devices = devices.pending
      #  when 'important' then devices = devices.important
      #end
    end

    unless (location_q = params[:location]).blank?
      devices = devices.where devices: {location_id: location_q}
    end
    
    unless (ticket_q = params[:ticket]).blank?
      devices = devices.where 'devices.ticket_number LIKE ?', "%#{ticket_q}%"
    end
    
    unless (device_q = params[:device]).blank?
      devices = devices.where 'LOWER(devices.serial_number) LIKE ?', "%#{device_q.downcase}%"
    end
    
    unless (client_q = params[:client]).blank?
      devices = devices.joins(:client).where 'LOWER(clients.name) LIKE :q OR clients.phone_number LIKE :q',
          q: "%#{client_q.downcase}%"
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
    location_name
  end

  def status_info
    {
      client: client_presentation,
      device_type: type_name,
      serial_number: serial_number,
      status: status
    }
  end

  def is_iphone?
    type_name.downcase['iphone'].present? if type_name.present?
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

end
