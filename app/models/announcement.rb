class Announcement < ActiveRecord::Base
  KINDS = %w[help coffee for_coffee protector info birthday order_status order_done salary device_return]

  belongs_to :user, inverse_of: :announcements
  has_and_belongs_to_many :recipients, class_name: 'User', join_table: 'announcements_users'
  attr_accessible :content, :kind, :user_id, :user, :active, :recipient_ids
  validates :kind, presence: true
  validates :kind, inclusion: { in: KINDS }
  scope :newest, order('created_at desc')
  scope :oldest, order('created_at asc')
  scope :active, where(active: true)
  scope :active_help, where(active: true, kind: 'help')
  scope :active_coffee, where(active: true, kind: 'coffee')
  scope :active_protector, where(active: true, kind: 'protector')
  scope :active_birthdays, where(active: true, kind: 'birthday')
  scope :device_return, where(kind: 'device_return')

  before_create :define_recipients

  after_initialize do |announcement|
    announcement.kind ||= 'info'
  end

  def user_name
    user.present? ? user.short_name : '-'
  end

  def help?
    kind == 'help'
  end

  def coffee?
    kind == 'coffee'
  end

  def for_coffee?
    kind == 'for_coffee'
  end

  def protector?
    kind == 'protector'
  end

  def birthday?
    kind == 'birthday'
  end

  def order_status?
    kind == 'order_status'
  end

  def order_done?
    kind == 'order_done'
  end

  def salary?
    kind == 'salary'
  end

  def device_return?
    kind == 'device_return'
  end

  def device
    Device.find(content.to_i)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def visible_for?(user)
    recipient_ids.include?(user.id) ||
      case kind
        when 'help' then (user_id != user.id and user.software?)
        when 'coffee' then user.software?
        when 'for_coffee' then user.media?
        when 'protector' then user.software?
        when 'birthday' then user.any_admin?
        when 'order_status' then user_id == user.id
        when 'order_done' then user_id == user.id or user.media?
      end
  end

  #def visible_for?(user)
  #  return recipient_ids.include?(user.id) or (user_id != user.id and user.software?) if help?
  #  return recipient_ids.include?(user.id) or user.software? if coffee?
  #  return recipient_ids.include?(user.id) or user.media? if for_coffee?
  #  return recipient_ids.include?(user.id) or user.software? if protector?
  #  return recipient_ids.include?(user.id) or user.admin? if birthday?
  #  return recipient_ids.include?(user.id) or user_id == user.id if order_status?
  #  return recipient_ids.include?(user.id) or (user_id == user.id or user.media?) if order_done?
  #  return recipient_ids.include?(user.id) if device_return?
  #  false
  #end

  def exclude_recipient(recipient)
    self.recipients.destroy recipient
    self.update_attribute :active, false if self.recipients.blank?
  end

  private

  def define_recipients
    case self.kind
      when 'help'
        recipients = User.software
      when 'coffee'
        recipients = User.software
      when 'for_coffee'
        recipients = User.media
      when 'protector'
        recipients = User.software
      when 'birthday'
        recipients = User.any_admin
      when 'order_status'
        recipients = User.where(id: self.user_id)
      when 'order_done'
        recipients = User.media
        recipients << User.where(id: self.user_id)
      when 'device_return'
        recipients = User.software.media
        recipients << User.technician if self.device.present? and self.device.location.is_repair?
      else
        recipients = []
    end
    self.recipient_ids = recipients.map { |r| r.id } if recipients.any?
  end

end
