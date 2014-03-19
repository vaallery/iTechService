class Order < ActiveRecord::Base

  belongs_to :customer, polymorphic: true
  belongs_to :user
  has_many :history_records, as: :object
  attr_accessible :customer_id, :customer_type, :comment, :desired_date, :object, :object_kind, :status, :user_id, :user_comment
  validates :customer_id, :object, :object_kind, presence: true
  before_validation :generate_number

  before_validation do |order|
    if order.new_record?
      if order.customer_id.blank?
        order.customer_id = User.current.id
        order.customer_type = 'User'
      else
        order.customer_type = 'Client'
      end
      order.user_id ||= User.current.id
    end
  end

  after_update :make_announcement

  scope :newest, order('orders.created_at desc')
  scope :oldest, order('orders.created_at asc')
  scope :new_orders, where(status: 'new')
  scope :pending_orders, where(status: 'pending')
  scope :done_orders, where(status: 'done')
  scope :canceled_orders, where(status: 'canceled')
  scope :notified_orders, where(status: 'notified')
  scope :archive_orders, where(status: 'archive')
  scope :actual_orders, where(status: %w[new pending notified done])
  scope :technician_orders, where(object_kind: 'spare_part')
  scope :marketing_orders, where('object_kind <> ?', 'spare_part')
  scope :device, where(object_kind: 'device')
  scope :accessory, where(object_kind: 'accessory')
  scope :soft, where(object_kind: 'soft')
  scope :misc, where(object_kind: 'misc')
  scope :spare_part, where(object_kind: 'spare_part')
  scope :done_at, lambda { |period| joins(:history_records).where(history_records: {column_name: 'status', new_value: 'done', created_at: period}) }

  OBJECT_KINDS = %w[device accessory soft misc spare_part]
  STATUSES = %w[new pending done canceled notified archive]

  def self.order_by_status
    ret = "CASE"
    STATUSES.each_with_index do |s, i|
      ret << " WHEN status = '#{s}' THEN #{i}"
    end
    ret << " END"
  end
  scope :by_status, order: order_by_status

  def customer_full_name
    customer.try :full_name
  end

  def customer_short_name
    customer.try :short_name
  end

  def customer_presentation
    customer.try :presentation
  end

  def client
    customer
  end

  def done?
    status == 'done'
  end

  def done_at
    history_records.where({column_name: 'status', new_value: 'done'}).last.try :created_at
  end

  def self.search params
    orders = Order.scoped

    if (status_q = params[:status]).present?
      orders = orders.where status: status_q if STATUSES.include? status_q
    else
      orders = orders.actual_orders
    end

    if (object_kind_q = params[:object_kind]).present?
      orders = orders.send object_kind_q if OBJECT_KINDS.include? object_kind_q
    end

    if (number_q = params[:order_number]).present?
      orders = orders.where 'number LIKE :q', q: "%#{number_q}%"
    end

    if (object_q = params[:object]).present?
      orders = orders.where 'LOWER(object) LIKE :q', q: "%#{object_q.mb_chars.downcase.to_s}%"
    end

    if (customer_q = params[:customer]).present?
      client_ids = Client.where('LOWER(clients.surname) LIKE :q OR LOWER(clients.name) LIKE :q OR LOWER(clients.patronymic) LIKE :q OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q', q: "%#{customer_q.mb_chars.downcase.to_s}%").map { |c| c.id }
      user_ids = User.where('LOWER(name) LIKE :q OR LOWER(surname) LIKE :q OR LOWER(username) LIKE :q', q: "%#{customer_q.mb_chars.downcase.to_s}%").select(:id).map { |u| u.id }
      orders = orders.where('(customer_type = ? AND customer_id IN (?)) OR (customer_type = ? AND customer_id IN (?))', 'Client', client_ids, 'User', user_ids)
    end

    if (user_q = params[:user]).present?
      orders = orders.joins(:user).where 'LOWER(users.name) LIKE :q OR LOWER(users.surname) LIKE :q OR LOWER(users.username) LIKE :q', q: "%#{user_q.mb_chars.downcase.to_s}%"
    end

    orders
  end

  def status_for_client
    status == 'done' ? 'done' : 'undone'
  end

  def status_info
    {
      status: status == 'done' ? 'done' : 'undone'
    }
  end

  private

  def generate_number
    if self.number.blank?
      begin num = UUIDTools::UUID.random_create.hash.to_s end while Order.exists? number: num
      self.number = num
    end
  end

  def make_announcement
    unless changed_attributes[:status].present?
      if (announcement = Announcement.create(user_id: self.user_id, kind: (done? ? 'order_done' : 'order_status'), active: true, content: "#{I18n.t('orders.order_num', num: number)} #{I18n.t('orders.statuses.'+status)}")).present?
        PrivatePub.publish_to '/announcements', "$.getScript('/announcements/#{announcement.id}');"
      end
    end
  end

end
