class Order < ActiveRecord::Base

  belongs_to :customer, polymorphic: true
  belongs_to :user
  has_many :history_records, as: :object
  attr_accessible :customer_id, :customer_type, :comment, :desired_date, :object, :object_kind, :status, :user_id,
                  :user_comment
  validates :customer_id, :object, :object_kind, presence: true
  before_validation :generate_number
  before_validation do |order|
    if order.customer_id.blank?
      order.customer_id = User.current.id
      order.customer_type = 'User'
    end
  end

  scope :ordered, order("orders.created_at desc")
  scope :new_orders, where(status: 'new')
  scope :pending_orders, where(status: 'pending')
  scope :done_orders, where(status: 'done')
  scope :canceled_orders, where(status: 'canceled')
  scope :actual_orders, where(status: %w[new pending])
  scope :device, where(object_kind: 'device')
  scope :accessory, where(object_kind: 'accessory')
  scope :soft, where(object_kind: 'soft')
  scope :misc, where(object_kind: 'misc')

  OBJECT_KINDS = %w[device accessory soft misc]
  STATUSES = %w[new pending done canceled]

  def customer_full_name
    customer.try :full_name
  end

  def customer_short_name
    customer.try :short_name
  end

  def customer_presentation
    customer_type == 'User' ? customer_full_name : customer.presentation
  end

  def client
    customer
  end

  def self.search params
    orders = Order.scoped

    unless (status_q = params[:status]).blank?
      orders = orders.send status_q+'_orders' if STATUSES.include? status_q
    end

    unless (object_kind_q = params[:object_kind]).blank?
      orders = orders.send object_kind_q if OBJECT_KINDS.include? object_kind_q
    end

    unless (number_q = params[:order_number]).blank?
      orders = orders.where number: number_q
    end

    unless (object_q = params[:object]).blank?
      orders = orders.where object: object_q
    end

    unless (customer_q = params[:customer]).blank?
      orders = orders.joins(:client, :user).where 'LOWER(clients.name) LIKE :q OR LOWER(users.name) LIKE :q
          OR LOWER(users.surname) LIKE :q OR LOWER(users.username) LIKE :q', q: "%#{customer_q.mb_chars.downcase.to_s}%"
    end

    orders
  end

  def status_for_client
    status == 'done' ? 'done' : 'undone'
  end

  private

  def generate_number
    if self.number.blank?
      begin num = UUIDTools::UUID.random_create.hash.to_s end while Order.exists? number: num
      self.number = num
    end
  end

end
