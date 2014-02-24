class QuickOrder < ActiveRecord::Base

  scope :id_asc, order('id asc')
  scope :created_desc, order('created_at desc')
  scope :in_month, where('created_at > ?', 1.month.ago)
  scope :undone, where(is_done: false)

  belongs_to :user
  has_and_belongs_to_many :quick_tasks
  attr_accessible :client_name, :comment, :contact_phone, :number, :is_done, :quick_task_ids
  before_create :set_number

  after_initialize do
    self.user_id ||= User.current.try(:id)
    self.is_done ||= false
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
