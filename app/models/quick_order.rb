class QuickOrder < ActiveRecord::Base

  DEVICE_KINDS = %w[iPhone iPad iPod]

  scope :id_asc, order('quick_orders.id asc')
  scope :created_desc, order('quick_orders.created_at desc')
  scope :in_month, where('quick_orders.created_at > ?', 1.month.ago)
  scope :done, where(is_done: true)
  scope :undone, where(is_done: false)

  belongs_to :department
  belongs_to :user
  has_and_belongs_to_many :quick_tasks
  has_many :history_records, as: :object, dependent: :destroy
  delegate :short_name, to: :user, prefix: true, allow_nil: true
  attr_accessible :client_name, :comment, :contact_phone, :number, :is_done, :quick_task_ids, :security_code, :department_id, :device_kind
  before_create :set_number
  validates_presence_of :security_code, :device_kind

  after_initialize do
    self.department_id ||= Department.current.id
    self.user_id ||= User.current.try(:id)
    self.is_done ||= false
  end

  def self.search(params)
    quick_orders = QuickOrder.scoped

    if (is_done = params[:done]).present?
      quick_orders = quick_orders.where is_done: is_done
    end

    if (number = params[:number]).present?
      quick_orders = quick_orders.where number: number
    end

    if (contact_phone = params[:contact_phone]).present?
      quick_orders = quick_orders.where 'quick_orders.contact_phone LIKE ?', "%#{contact_phone}%"
    end

    if (task = params[:task]).present?
      quick_orders = quick_orders.includes(:quick_tasks).where('LOWER(quick_tasks.name) LIKE ?',
                                                               "%#{task.mb_chars.downcase.to_s}%")
    end

    quick_orders
  end

  def set_done
    update_attributes is_done: true
  end

  def number_s
    sprintf('%04d', number)
  end

  private

  def set_number
    last_number = QuickOrder.created_desc.first.try(:number)
    self.number = (last_number.present? and last_number < 9999) ? last_number.next : 1
  end

end
